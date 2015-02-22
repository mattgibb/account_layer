class RemoveDueAtFromTransaction < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE transactions
        DROP due_at,
        ALTER paid_at SET NOT NULL;
    }
  end

  def down
    execute %{
      ALTER TABLE transactions
        ADD due_at timestamp with time zone,
        ALTER paid_at DROP NOT NULL,
        ADD CONSTRAINT either_due_or_paid CHECK (due_at IS NOT NULL OR paid_at IS NOT NULL);
    }
  end
end
