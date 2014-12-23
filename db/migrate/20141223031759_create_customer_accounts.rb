class CreateCustomerAccounts < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE customer_accounts (
        id bigserial PRIMARY KEY,
        user_id bigint UNIQUE NOT NULL,
        type text NOT NULL,
        balance non_negative_currency,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
      );
    }
  end

  def down
    execute "DROP TABLE customer_accounts;"
  end
end
