class CreateControlAccounts < ActiveRecord::Migration
  def up
    execute %{
      CREATE DOMAIN currency              numeric NOT NULL DEFAULT 0;
      CREATE DOMAIN positive_currency     numeric NOT NULL DEFAULT 0 CONSTRAINT non_negative CHECK (VALUE >  0);
      CREATE DOMAIN non_negative_currency numeric NOT NULL DEFAULT 0 CONSTRAINT non_negative CHECK (VALUE >= 0);
      CREATE DOMAIN non_positive_currency numeric NOT NULL DEFAULT 0 CONSTRAINT non_positive CHECK (VALUE <= 0);

      CREATE TABLE control_accounts (
          id bigserial PRIMARY KEY,
          name text NOT NULL,
          balance currency,
          created_at timestamp with time zone NOT NULL,
          updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
      );
    }
  end

  def down
    execute %{
      DROP TABLE control_accounts;

      DROP DOMAIN currency;
      DROP DOMAIN positive_currency;
      DROP DOMAIN non_negative_currency;
      DROP DOMAIN non_positive_currency;
    }
  end
end
