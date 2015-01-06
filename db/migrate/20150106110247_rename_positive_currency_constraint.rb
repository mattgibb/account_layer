class RenamePositiveCurrencyConstraint < ActiveRecord::Migration
  def up
    execute "ALTER DOMAIN positive_currency RENAME CONSTRAINT non_negative TO positive;"
  end

  def down
    execute "ALTER DOMAIN positive_currency RENAME CONSTRAINT positive TO non_negative;"
  end
end
