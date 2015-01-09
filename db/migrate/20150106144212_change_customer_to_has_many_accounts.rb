class ChangeCustomerToHasManyAccounts < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE customers DROP COLUMN account_id;
      ALTER TABLE accounts ADD COLUMN customer_id bigint REFERENCES customers;
      ALTER TABLE accounts ADD CONSTRAINT accounts_customer_id_check
        CHECK ((customer_id IS     NULL AND belongs_to_customer=false) OR
               (customer_id IS NOT NULL AND belongs_to_customer=true));
    }
  end

  def down
    execute %{
      ALTER TABLE customers ADD COLUMN account_id bigint;
      ALTER TABLE accounts DROP CONSTRAINT accounts_customer_id_check;
      ALTER TABLE accounts DROP COLUMN account_id bigint;
    }
  end
end
