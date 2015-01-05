class AddIdToAdmin < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE admins DROP CONSTRAINT admins_pkey;
      ALTER TABLE admins ADD UNIQUE (email);
      ALTER TABLE admins ADD COLUMN id bigserial PRIMARY KEY;
    }
  end

  def down
    execute %{
      ALTER TABLE admins DROP COLUMN id;
      ALTER TABLE admins ADD PRIMARY KEY (email);
    }
  end
end
