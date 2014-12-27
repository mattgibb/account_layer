class CreateTransactions < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE transactions (
        id bigserial PRIMARY KEY,
        credit_id bigint REFERENCES accounts,
        debit_id bigint REFERENCES accounts,
        amount positive_currency,
        comment text,
        due_at timestamp with time zone,
        paid_at timestamp with time zone,
        created_at audit_timestamp,
        updated_at audit_timestamp,
        CONSTRAINT dont_pay_yourself CHECK (debit_id <> credit_id),
        CONSTRAINT either_due_or_paid CHECK (due_at IS NOT NULL OR paid_at IS NOT NULL)
      );
    }
  end

  def down
    execute "DROP TABLE transactions;"
  end
end
