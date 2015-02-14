class CreateFirstAssociatesReconciliations < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE first_associates_reconciliations (
        id bigserial PRIMARY KEY,
        transaction_id                  bigint UNIQUE NOT NULL REFERENCES transactions,
        first_associates_transaction_id bigint UNIQUE NOT NULL REFERENCES first_associates_transactions,
        admin_id                        bigint        NOT NULL REFERENCES admins,
        created_at audit_timestamp,
        updated_at audit_timestamp
      );
    }
  end

  def down
    execute "DROP TABLE first_associates_reconciliations;"
  end
end
