class CheckForNamespacedAccounts < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE account_groups    DROP CONSTRAINT account_group_types;
      ALTER TABLE cohort_profiles   DROP CONSTRAINT cohort_profiles_account_group_type_check;
      ALTER TABLE customer_profiles DROP CONSTRAINT customer_profiles_account_group_type_check;

      ALTER TABLE account_groups ADD CONSTRAINT account_group_types
        CHECK (type IN ('AccountGroup::Lender', 'AccountGroup::Borrower', 'AccountGroup::School', 'AccountGroup::Cohort'));
      ALTER TABLE cohort_profiles ADD CONSTRAINT cohort_profiles_account_group_type_check
        CHECK (account_group_type = 'AccountGroup::Cohort');
      ALTER TABLE customer_profiles ADD CONSTRAINT customer_profiles_account_group_type_check
        CHECK (account_group_type IN ('AccountGroup::Lender', 'AccountGroup::Borrower', 'AccountGroup::School'));
    }
  end
end
