class FirstAssociatesReportLoader
  class ParseError < RuntimeError; end

  CASH_HEADERS = [
    "Transaction Date",
    "Effective Date",
    "G/L Date",
    "Loan Number",
    "Short Name",
    "Payment Method",
    "Payment Method Reference",
    "Principal",
    "Interest",
    "Fees",
    "Late Charges",
    "UDBs",
    "Suspense",
    "Impound",
    "Payment Amount"
  ]

  def initialize(admin, document)
    @admin = admin
    @document = document.respond_to?(:read) ? document.read.b : document.b
  end

  def load
    return false if report_already_loaded?

    ActiveRecord::Base.transaction do
      save_report
      save_transactions
    end
    true
  end

  private

    def report_already_loaded?
      FirstAssociatesReport.where(contents: @document).exists?
    end

    def save_report
      @report = FirstAssociatesReport.create admin_id: @admin.id,
                                             contents: @document
    end

    def save_transactions
      transactions.each do |txn|
        @report.first_associates_transactions.create(
          transaction_date: parse_date(txn[0]),
          effective_date: parse_date(txn[1]),
          g_l_date: parse_date(txn[2]),
          loan_number: txn[3],
          short_name: txn[4],
          payment_method: txn[5],
          payment_method_reference: txn[6],
          principal: txn[7],
          interest: txn[8],
          fees: txn[9],
          late_charges: txn[10],
          udbs: txn[11],
          suspense: txn[12],
          impound: txn[13],
          payment_amount: txn[14]
        )
      end
    end

    def transactions
      return @transactions if @transactions # memoize

      cash = sheets["Cash"]

      # check header format
      unless cash[7] == CASH_HEADERS
        raise ParseError, "The Cash sheet column headers are wrong."
      end

      @transactions = cash[8..-1]
    end

    def sheets
      @sheets ||= SimpleXlsxReader.open(tempfile.path).to_hash
    end

    # simple_xlsx_reader only works with files, not streams
    def tempfile
      @tempfile ||= Tempfile.new('report.xlsx', encoding: 'ascii-8bit').tap do |xlsx|
        xlsx.write @document
      end
    end

    def parse_date(str)
      Time.strptime(str, "%m/%d/%Y")
    end
end
