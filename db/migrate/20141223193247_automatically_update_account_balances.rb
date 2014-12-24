class AutomaticallyUpdateAccountBalances < ActiveRecord::Migration
  def up
    execute %{
      CREATE FUNCTION update_account_balance(account_id accounts.id%TYPE)
        RETURNS void AS
        $BODY$
        BEGIN
          WITH debit AS (
            SELECT coalesce(sum(amount), 0) total FROM transactions WHERE debit_id=account_id
          ), credit AS (
            SELECT coalesce(sum(amount), 0) total FROM transactions WHERE credit_id=account_id
          )
          UPDATE accounts SET balance = (CASE credit_or_debit WHEN 'debit' THEN 1 ELSE -1 END) *
                                          ((SELECT total FROM debit) -
                                           (SELECT total FROM credit))
                          WHERE id=account_id;
        END
        $BODY$
        LANGUAGE plpgsql;

      CREATE FUNCTION update_balances()
        RETURNS trigger AS
        $BODY$
        BEGIN
          PERFORM update_account_balance(NEW.debit_id);
          PERFORM update_account_balance(NEW.credit_id);
          RETURN NEW;
        END
        $BODY$
        LANGUAGE plpgsql;

      CREATE TRIGGER update_balances
        AFTER INSERT OR UPDATE OR DELETE
        ON transactions
        FOR EACH ROW
        EXECUTE PROCEDURE update_balances();
    }
  end

  def down
    execute %{
      DROP TRIGGER update_balances ON transactions;
      DROP FUNCTION update_balances();
      DROP FUNCTION update_account_balance(bigint);
    }
  end
end
