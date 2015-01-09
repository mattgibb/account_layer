class ChangePrimaryKeyOnCustomers < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE customers DROP COLUMN customer_id;
      ALTER TABLE customers ADD  COLUMN customer_id bigint    UNIQUE NOT NULL;
      ALTER TABLE customers ADD  COLUMN id          bigserial PRIMARY KEY;
    }
  end

  def down
    execute %{
      ALTER TABLE customers DROP COLUMN id;
      ALTER TABLE customers ADD  COLUMN id          UNIQUE NOT NULL;
      ALTER TABLE customers ADD  COLUMN customer_id PRIMARY KEY;
    }
  end
end
