class CreateFirstAssociatesReports < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE first_associates_reports (
        id bigserial PRIMARY KEY,
        admin_id bigint REFERENCES admins NOT NULL,
        contents text UNIQUE NOT NULL,
        created_at audit_timestamp,
        updated_at audit_timestamp
      )
    }
  end

  def down
    execute "DROP TABLE first_associates_reports;"
  end
end
