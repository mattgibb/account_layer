class CreateCustomers < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE customers (
        customer_id bigint NOT NULL,
        account_id bigint REFERENCES accounts NOT NULL,
        type text NOT NULL,
        created_at audit_timestamp,
        updated_at audit_timestamp,
        CONSTRAINT unique_customer_account PRIMARY KEY (customer_id, type)
      );
    }
  end

  def down
    execute "DROP TABLE customers;"
  end
end
