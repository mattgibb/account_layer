class FixDeleteTriggerOnTransactions < ActiveRecord::Migration
  def up
    execute %{
      DROP TRIGGER update_balances ON transactions;
      DROP FUNCTION update_balances();

      CREATE FUNCTION insert_transaction_update_balances()
        RETURNS trigger AS
        $BODY$
        BEGIN
          PERFORM update_account_balance(NEW.debit_id);
          PERFORM update_account_balance(NEW.credit_id);
          RETURN NULL; -- result is ignored since this is an AFTER trigger
        END
        $BODY$
        LANGUAGE plpgsql;

      CREATE FUNCTION update_transaction_update_balances()
        RETURNS trigger AS
        $BODY$
        BEGIN
          PERFORM update_account_balance(id) from 
            (SELECT DISTINCT id FROM
              (VALUES (OLD.credit_id),
                      (OLD.debit_id),
                      (NEW.credit_id),
                      (NEW.debit_id)
              ) account_ids(id)
            ) distinct_account_ids(id);
          RETURN NULL; -- result is ignored since this is an AFTER trigger
        END
        $BODY$
        LANGUAGE plpgsql;

      CREATE FUNCTION delete_transaction_update_balances()
        RETURNS trigger AS
        $BODY$
        BEGIN
          PERFORM update_account_balance(OLD.debit_id);
          PERFORM update_account_balance(OLD.credit_id);
          RETURN NULL; -- result is ignored since this is an AFTER trigger
        END
        $BODY$
        LANGUAGE plpgsql;

      CREATE TRIGGER insert_transaction_update_balances
        AFTER INSERT ON transactions
        FOR EACH ROW
        EXECUTE PROCEDURE insert_transaction_update_balances();

      CREATE TRIGGER update_transaction_update_balances
        AFTER UPDATE ON transactions
        FOR EACH ROW
        EXECUTE PROCEDURE update_transaction_update_balances();

      CREATE TRIGGER delete_transaction_update_balances
        AFTER INSERT ON transactions
        FOR EACH ROW
        EXECUTE PROCEDURE delete_transaction_update_balances();
    }
  end
  
  def down
    execute %{
      DROP TRIGGER insert_transaction_update_balances ON transactions;
      DROP TRIGGER update_transaction_update_balances ON transactions;
      DROP TRIGGER delete_transaction_update_balances ON transactions;
      DROP FUNCTION insert_transaction_update_balances();
      DROP FUNCTION update_transaction_update_balances();
      DROP FUNCTION delete_transaction_update_balances();

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
end
