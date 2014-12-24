class CreateAccounts < ActiveRecord::Migration
  def up
    execute %{
      CREATE DOMAIN currency              numeric NOT NULL DEFAULT 0;
      CREATE DOMAIN positive_currency     numeric NOT NULL DEFAULT 0 CONSTRAINT non_negative CHECK (VALUE >  0);
      CREATE DOMAIN non_negative_currency numeric NOT NULL DEFAULT 0 CONSTRAINT non_negative CHECK (VALUE >= 0);
      CREATE DOMAIN non_positive_currency numeric NOT NULL DEFAULT 0 CONSTRAINT non_positive CHECK (VALUE <= 0);
      CREATE DOMAIN credit_or_debit text NOT NULL CONSTRAINT credit_or_debit CHECK (VALUE IN ('credit', 'debit'));
      CREATE DOMAIN audit_timestamp timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP;

      -- dynamic enum/foreign key for account types
      -- easier to add accounts than a check constraint, enum or domain
      CREATE TABLE account_types (
        type text,
        credit_or_debit credit_or_debit,
        PRIMARY KEY (type, credit_or_debit)
      );

      CREATE TABLE accounts (
        id bigserial PRIMARY KEY,
        name text NOT NULL,
        balance non_negative_currency,
        type text,
        credit_or_debit credit_or_debit,
        created_at audit_timestamp,
        updated_at audit_timestamp,
        FOREIGN KEY (type, credit_or_debit) REFERENCES account_types
      );
    }
  end

  def down
    execute %{
      DROP TABLE accounts;
      DROP TABLE account_types;

      DROP DOMAIN currency;
      DROP DOMAIN positive_currency;
      DROP DOMAIN non_negative_currency;
      DROP DOMAIN non_positive_currency;
      DROP DOMAIN credit_or_debit;
      DROP DOMAIN audit_timestamp;
    }
  end
end
