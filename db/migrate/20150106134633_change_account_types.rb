class ChangeAccountTypes < ActiveRecord::Migration
  def up
    execute %{
      -- add belongs_to_customer to account_types
      ALTER TABLE account_types ADD COLUMN belongs_to_customer boolean;
      UPDATE account_types SET belongs_to_customer=false;
      ALTER TABLE account_types ALTER COLUMN belongs_to_customer SET NOT NULL;

      -- add belongs_to_customer to account_types primary key
      ALTER TABLE account_types DROP CONSTRAINT account_types_pkey CASCADE;
      ALTER TABLE account_types ADD PRIMARY KEY (type, credit_or_debit, belongs_to_customer);

      -- add belongs_to_customer to accounts
      ALTER TABLE accounts ADD COLUMN belongs_to_customer boolean;
      UPDATE accounts SET belongs_to_customer=false;
      ALTER TABLE accounts ALTER COLUMN belongs_to_customer SET NOT NULL;

      -- add belongs_to_customer to accounts foreign key
      ALTER TABLE accounts ADD CONSTRAINT accounts_type_fkey
        FOREIGN KEY (type, credit_or_debit, belongs_to_customer)
        REFERENCES account_types MATCH FULL;
    }
  end

  def down
    execute %{
      ALTER TABLE account_types DROP CONSTRAINT account_types_pkey CASCADE;
      ALTER TABLE account_types ADD PRIMARY KEY (type, credit_or_debit);
      ALTER TABLE account_types DROP COLUMN belongs_to_customer;
      ALTER TABLE accounts      DROP COLUMN belongs_to_customer;

      ALTER TABLE accounts ADD CONSTRAINT accounts_type_fkey
        FOREIGN KEY (type, credit_or_debit)
        REFERENCES account_types MATCH FULL;
    }
  end
end
