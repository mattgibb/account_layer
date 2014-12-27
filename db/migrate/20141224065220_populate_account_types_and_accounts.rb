class PopulateAccountTypesAndAccounts < ActiveRecord::Migration
  def up
    execute %{
      INSERT INTO account_types VALUES
        ('ControlAccount',  'credit'),
        ('ControlAccount',  'debit'),
        ('LoanAccount',     'debit'),
        ('PayableAccount',  'debit'),
        ('CashAccount',     'debit'),
        ('HoldbackAccount', 'credit');

      INSERT INTO accounts
        (name, type, credit_or_debit)
        VALUES
        ('Origination Fees', 'ControlAccount', 'credit'),
        ('Servicing Fees',   'ControlAccount', 'credit'),
        ('Chargeoffs',       'ControlAccount', 'credit'),
        ('Recoveries',       'ControlAccount', 'credit');
    }
  end

  def down
    execute %{
    }
  end
end
