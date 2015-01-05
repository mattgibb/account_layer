class CreateBankStatements < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE bank_statements (
        id bigserial PRIMARY KEY,
        admin_id bigint REFERENCES admins NOT NULL,
        contents text UNIQUE NOT NULL,
        account_number bigint,
        created_at audit_timestamp,
        updated_at audit_timestamp
      )
    }
  end

  def down
    execute "DROP TABLE bank_statements;"
  end
end
