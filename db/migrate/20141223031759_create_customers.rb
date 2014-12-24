class CreateCustomers < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE customers (
        customer_id bigint PRIMARY KEY,
        account_id bigint REFERENCES accounts,
        created_at audit_timestamp,
        updated_at audit_timestamp
      );
    }
  end

  def down
    execute "DROP TABLE customers;"
  end
end
