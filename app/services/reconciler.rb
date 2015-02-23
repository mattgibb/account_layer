class Reconciler
  def initialize(reconcilable, other_account_id, reconciliations, admin)
    @reconcilable     = reconcilable
    @other_account_id = other_account_id
    @reconciliations  = reconciliations
    @admin            = admin
  end

  def reconcile!
    ActiveRecord::Base.transaction do
      @reconciliations.each do |account_id, amount|
        transaction_id = create_transaction(account_id, amount).id
        @reconcilable.reconciliations.create transaction_id: transaction_id,
                                             admin_id: @admin.id
      end
    end
    true
  end

  def reconcile(*args)
    begin
      reconcile! *args
    rescue ActiveRecord::StatementInvalid => e
      raise unless PG::CheckViolation === e.cause
      false
    end
  end

  private

    def create_transaction(account_id, amount)
      credit_id = amount > 0 ? account_id : @other_account_id
      debit_id  = amount > 0 ? @other_account_id : account_id

      Transaction.create(credit_id: credit_id,
                         debit_id: debit_id,
                         amount: amount.abs,
                         paid_at: Time.now)
    end
end
