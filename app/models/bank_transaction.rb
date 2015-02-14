class BankTransaction < ActiveRecord::Base
  belongs_to :bank_statement
  has_one :reconciliation, class: BankReconciliation

  def reconciled?
    !!reconciliation && reconciliation.persisted?
  end

  def reconcile!(other_account_id, current_admin)
    transaction do # database transaction, not financial transaction
      create_reconciliation transaction_id: create_transaction(other_account_id).id,
                            admin_id: current_admin.id
    end
  end

  private

    def create_transaction(other_account_id)
      credit_id = incoming? ? other_account_id : wells_fargo_id
      debit_id  = incoming? ? wells_fargo_id : other_account_id

      Transaction.create credit_id: credit_id,
                         debit_id: debit_id,
                         amount: amount.abs,
                         paid_at: Time.now
    end

    def incoming?
      amount > 0
    end

    def wells_fargo_id
      Account.wells_fargo_cash.id
    end
end
