class CreateTransactions < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE transactions (
        id bigserial PRIMARY KEY,
        debit_id bigserial REFERENCES accounts,
        credit_id bigserial REFERENCES accounts,
        amount positive_currency,
        comment text,
        created_at created_at,
        updated_at updated_at
      );
    }
  end

  def down
    execute "DROP TABLE transactions;"
  end
end
