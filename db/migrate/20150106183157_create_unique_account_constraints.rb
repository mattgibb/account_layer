class CreateUniqueAccountConstraints < ActiveRecord::Migration
  def up
    execute %{
      CREATE UNIQUE INDEX unique_control_accounts ON accounts (name) WHERE customer_id IS NULL;
      ALTER TABLE accounts ADD CONSTRAINT unique_customer_accounts UNIQUE (type,credit_or_debit,customer_id);
    }
  end
  
  def down
    execute %{
      DROP INDEX unique_control_accounts;
      ALTER TABLE accounts DROP CONSTRAINT unique_customer_accounts;
    }
  end
end
