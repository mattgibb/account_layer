class CreateCustomers < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE customers (
        customer_id bigint PRIMARY KEY,
        account_id bigint REFERENCES accounts,
        created_at created_at,
        updated_at updated_at
      );
    }
  end

  def down
    execute "DROP TABLE customers;"
  end
end
