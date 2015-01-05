class CreateBankTransactions < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE bank_transactions (
        id bigserial PRIMARY KEY,
        bank_statement_id bigint REFERENCES bank_statements NOT NULL,
        transaction_type text,
        date_posted timestamp without time zone,
        amount currency,
        transaction_id bigint,
        name text,
        memo text,
        created_at audit_timestamp,
        updated_at audit_timestamp
      )
    }
  end

  def down
    execute "DROP TABLE bank_transactions;"
  end
end
