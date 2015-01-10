class CreateReconciliations < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE reconciliations (
        id bigserial PRIMARY KEY,
        transaction_id      bigint UNIQUE NOT NULL REFERENCES transactions,
        bank_transaction_id bigint UNIQUE NOT NULL REFERENCES bank_transactions,
        admin_id            bigint        NOT NULL REFERENCES admins,
        created_at audit_timestamp,
        updated_at audit_timestamp
      );
    }
  end

  def down
    execute %{
      DROP TABLE reconciliations;
    }
  end
end
