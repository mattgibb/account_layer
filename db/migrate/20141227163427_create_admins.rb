class CreateAdmins < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE admins (
        email text PRIMARY KEY,
        name text NOT NULL,
        created_at audit_timestamp,
        updated_at audit_timestamp
      )
    }
  end

  def down
    execute "DROP TABLE admins;"
  end
end
