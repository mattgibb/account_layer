class AddNotNullToForeignKeyFields < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE accounts     ALTER COLUMN type      SET NOT NULL;
      ALTER TABLE transactions ALTER COLUMN credit_id SET NOT NULL;
      ALTER TABLE transactions ALTER COLUMN debit_id  SET NOT NULL;
    }
  end

  def down
    execute %{
      ALTER TABLE accounts     ALTER COLUMN type      DROP NOT NULL;
      ALTER TABLE transactions ALTER COLUMN credit_id DROP NOT NULL;
      ALTER TABLE transactions ALTER COLUMN debit_id  DROP NOT NULL;
    }
  end
end
