class FirstAssociatesTransaction < ActiveRecord::Base
  belongs_to :first_associates_report
  has_one :reconciliation, class: FirstAssociatesReconciliation

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
      Transaction.create credit_id: other_account_id,
                         debit_id: receivables_account_id,
                         amount: payment_amount,
                         paid_at: Time.now
    end

    def receivables_account_id
      Account.first_associates_receivables.id
    end
end
