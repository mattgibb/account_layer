class CreateAccounts < ActiveRecord::Migration
  def up
    execute %{
      CREATE DOMAIN currency              numeric NOT NULL DEFAULT 0;
      CREATE DOMAIN positive_currency     numeric NOT NULL DEFAULT 0 CONSTRAINT non_negative CHECK (VALUE >  0);
      CREATE DOMAIN non_negative_currency numeric NOT NULL DEFAULT 0 CONSTRAINT non_negative CHECK (VALUE >= 0);
      CREATE DOMAIN non_positive_currency numeric NOT NULL DEFAULT 0 CONSTRAINT non_positive CHECK (VALUE <= 0);
      CREATE DOMAIN debit_or_credit text NOT NULL CONSTRAINT debit_or_credit CHECK (VALUE IN ('debit', 'credit'));
      CREATE DOMAIN created_at timestamp with time zone NOT NULL;
      CREATE DOMAIN updated_at created_at DEFAULT CURRENT_TIMESTAMP;

      -- dynamic enum/foreign key for account types
      -- easier to add accounts than a check constraint, enum or domain
      CREATE TABLE account_types (
        type text,
        debit_or_credit debit_or_credit,
        PRIMARY KEY (type, debit_or_credit)
      );

      CREATE TABLE accounts (
        id bigserial PRIMARY KEY,
        name text NOT NULL,
        balance non_negative_currency,
        type text,
        debit_or_credit debit_or_credit,
        created_at created_at,
        updated_at updated_at,
        FOREIGN KEY (type, debit_or_credit) REFERENCES account_types
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
      DROP DOMAIN debit_or_credit;
      DROP DOMAIN created_at;
      DROP DOMAIN updated_at;
    }
  end
end
