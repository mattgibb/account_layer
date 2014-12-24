class CreateTransactions < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE transactions (
        id bigserial PRIMARY KEY,
        credit_id bigint REFERENCES accounts,
        debit_id bigint REFERENCES accounts,
        amount positive_currency,
        comment text,
        created_at audit_timestamp,
        updated_at audit_timestamp,
        CONSTRAINT dont_pay_yourself CHECK (debit_id <> credit_id)
      );
    }
  end

  def down
    execute "DROP TABLE transactions;"
  end
end
