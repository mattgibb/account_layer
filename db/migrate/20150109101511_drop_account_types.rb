class DropAccountTypes < ActiveRecord::Migration
  def up
    execute %{
      DROP TABLE account_types CASCADE;
      DROP INDEX unique_control_accounts;
      CREATE UNIQUE INDEX unique_lendlayer_accounts
        ON accounts (type)
        WHERE (account_group_id IS NULL);
      ALTER TABLE accounts DROP CONSTRAINT unique_customer_accounts;
      ALTER TABLE accounts
        ADD CONSTRAINT unique_customer_accounts
        UNIQUE (type, account_group_id);
      ALTER TABLE accounts DROP COLUMN belongs_to_customer;
      ALTER TABLE accounts DROP COLUMN name;
    }
  end

  def down
    execute %{
      CREATE TABLE account_types (
        type text NOT NULL,
        credit_or_debit credit_or_debit NOT NULL,
        belongs_to_customer boolean NOT NULL,
        PRIMARY KEY (type, credit_or_debit, belongs_to_customer)
      );
      ALTER TABLE accounts ADD COLUMN name text not null;
      ALTER TABLE accounts ADD COLUMN belongs_to_customer boolean not null;
      ALTER TABLE accounts ADD CONSTRAINT accounts_customer_id_check
        CHECK ((((account_group_id IS NULL)     AND (belongs_to_customer = false))
          OR    ((account_group_id IS NOT NULL) AND (belongs_to_customer = true))));
      ALTER TABLE accounts
        ADD CONSTRAINT accounts_type_fkey
        FOREIGN KEY             (type, credit_or_debit, belongs_to_customer)
        REFERENCES account_types(type, credit_or_debit, belongs_to_customer) MATCH FULL;
      DROP INDEX unique_lendlayer_accounts;
      CREATE UNIQUE INDEX unique_control_accounts
        ON accounts (name)
        WHERE (account_group_id IS NULL);
      ALTER TABLE accounts DROP CONSTRAINT unique_customer_accounts;
      ALTER TABLE accounts
        ADD CONSTRAINT unique_customer_accounts UNIQUE (type, credit_or_debit, account_group_id);
    }
  end
end
