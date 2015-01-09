class AddUniqueCustomerProfile < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE customer_profiles ADD CONSTRAINT customer_profiles_unique_account_group UNIQUE (account_group_id);
      ALTER TABLE cohort_profiles   ADD CONSTRAINT cohort_profiles_unique_account_group   UNIQUE (account_group_id);
    }
  end

  def down
    execute %{
      ALTER TABLE customer_profiles DROP CONSTRAINT customer_profiles_unique_account_group;
      ALTER TABLE cohort_profiles   DROP CONSTRAINT cohort_profiles_unique_account_group;
    }
  end
end
