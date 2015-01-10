class RemoveReconciliationIdFromBankTransactions < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE bank_transactions
        DROP COLUMN reconciliation_id;
    }
  end

  def down
    execute %{
      ALTER TABLE bank_transactions
        ADD COLUMN reconciliation_id bigint REFERENCES transactions;
    }
  end
end
