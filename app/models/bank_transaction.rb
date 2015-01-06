class BankTransaction < ActiveRecord::Base
  belongs_to :bank_statement
  belongs_to :reconciliation, class_name: 'Transaction', foreign_key: :reconciliation_id

  def reconciled?
    !reconciliation_id.nil?
  end
end
