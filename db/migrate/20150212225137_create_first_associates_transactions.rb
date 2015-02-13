class CreateFirstAssociatesTransactions < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE first_associates_transactions (
        id bigserial PRIMARY KEY,
        first_associates_report_id bigint REFERENCES first_associates_reports NOT NULL,
        transaction_date date,
        effective_date date,
        g_l_date date,
        loan_number integer,
        short_name text,
        payment_method text,
        payment_method_reference text,
        principal non_negative_currency,
        interest non_negative_currency,
        fees non_negative_currency,
        late_charges non_negative_currency,
        udbs non_negative_currency,
        suspense non_negative_currency,
        impound non_negative_currency,
        payment_amount non_negative_currency,
        created_at audit_timestamp,
        updated_at audit_timestamp
      )
    }
  end

  def down
    execute "DROP TABLE first_associates_transactions;"
  end
end
