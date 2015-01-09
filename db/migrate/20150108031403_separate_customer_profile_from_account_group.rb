class SeparateCustomerProfileFromAccountGroup < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE customers RENAME TO account_groups;
      ALTER TABLE account_groups DROP COLUMN customer_id;
      ALTER TABLE account_groups ADD CONSTRAINT account_group_types
        CHECK (type IN ('Lender', 'Borrower', 'School', 'Cohort'));
      ALTER TABLE account_groups ADD CONSTRAINT account_groups_unique_id_type
        UNIQUE (id, type);
      ALTER TABLE accounts RENAME customer_id TO account_group_id;
      CREATE TABLE customer_profiles (
        id bigserial PRIMARY KEY,
        account_group_id bigint NOT NULL,
        account_group_type text NOT NULL CHECK (account_group_type IN ('Lender', 'Borrower', 'School')),
        lendlayer_id bigint UNIQUE NOT NULL,
        name text NOT NULL,
        FOREIGN KEY (account_group_id, account_group_type) REFERENCES account_groups (id, type)
      );
      CREATE TABLE cohort_profiles (
        id bigserial PRIMARY KEY,
        account_group_id bigint NOT NULL,
        account_group_type text NOT NULL CHECK (account_group_type = 'Cohort'),
        lendlayer_id bigint UNIQUE NOT NULL,
        FOREIGN KEY (account_group_id, account_group_type) REFERENCES account_groups (id, type) MATCH FULL
      );
    }
  end

  def down
    execute %{
      DROP TABLE customer_profiles;
      DROP TABLE cohort_profiles;
      ALTER TABLE accounts RENAME account_group_id TO customer_id;
      ALTER TABLE account_groups DROP CONSTRAINT account_groups_unique_id_type;
      ALTER TABLE account_groups DROP CONSTRAINT account_group_types;
      ALTER TABLE account_groups ADD COLUMN customer_id bigint UNIQUE;
      ALTER TABLE account_groups RENAME TO customers;
    }
  end
end
