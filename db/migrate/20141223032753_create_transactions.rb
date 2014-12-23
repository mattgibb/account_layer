class CreateTransactions < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE transactions (
        id bigserial PRIMARY KEY,
        customer_debit_id bigserial REFERENCES customer_accounts,
        customer_credit_id bigserial REFERENCES customer_accounts,
        control_debit_id bigserial REFERENCES control_accounts,
        control_credit_id bigserial REFERENCES control_accounts,
        amount positive_currency,
        comment text,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT single_debit_id  CHECK (NOT (customer_debit_id IS     NULL AND control_debit_id IS     NULL) AND
                                           NOT (customer_debit_id IS NOT NULL AND control_debit_id IS NOT NULL)),
        CONSTRAINT single_credit_id CHECK (NOT (customer_credit_id IS     NULL AND control_credit_id IS     NULL) AND
                                           NOT (customer_credit_id IS NOT NULL AND control_credit_id IS NOT NULL))
      );
    }
  end

  def down
    execute "DROP TABLE transactions;"
  end
end
