class BankTransaction < ActiveRecord::Base
  belongs_to :bank_statement
  has_many :reconciliations, class: BankReconciliation

  def reconciled?
    !!reconciliation && reconciliation.persisted?
  end
end
