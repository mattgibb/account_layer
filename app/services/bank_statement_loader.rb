class BankStatementLoader
  def initialize(admin, statement_string)
    @admin, @statement = admin, statement_string
  end

  def load
    ActiveRecord::Base.transaction do
      save_statement
      save_transactions
    end
  end

  private
    
    def save_statement
      @statement = BankStatement.create admin_id: @admin.id, 
                                        contents: @statement,
                                        account_number: account.number
    end

    def save_transactions
      account.transactions.each do |txn|
        @statement.bank_transactions.create transaction_type: txn.type,
                                            date_posted: txn.timestamp,
                                            amount: txn.amount,
                                            transaction_id: txn.number,
                                            name: txn.name,
                                            memo: txn.memo
      end
    end

    def account
      @account ||= QuickenParser.parse(@statement).first
    end
end
