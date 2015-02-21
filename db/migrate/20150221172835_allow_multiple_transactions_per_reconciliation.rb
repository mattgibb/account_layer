class AllowMultipleTransactionsPerReconciliation < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE bank_reconciliations
        DROP CONSTRAINT reconciliations_bank_transaction_id_key;
      ALTER TABLE first_associates_reconciliations
        DROP CONSTRAINT first_associates_reconciliati_first_associates_transaction__key;
    }
  end

  def down
    execute %{
      ALTER TABLE bank_reconciliations
        ALTER  bank_transaction_id
        ADD CONSTRAINT UNIQUE;
      ALTER TABLE first_associates_reconciliations
        ALTER first_associates_transaction_id
        ADD CONSTRAINT UNIQUE;
    }
  end
end
