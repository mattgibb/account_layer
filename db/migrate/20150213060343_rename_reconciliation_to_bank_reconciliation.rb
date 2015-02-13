class RenameReconciliationToBankReconciliation < ActiveRecord::Migration
  def change
    rename_table :reconciliations, :bank_reconciliations
  end
end
