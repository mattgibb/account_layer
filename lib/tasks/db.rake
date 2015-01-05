namespace :db do
  desc "Inserts the set of different account types for the accounts table"
  task seed_account_types: :environment do
    ActiveRecord::Base.connection.execute %{
      INSERT INTO account_types VALUES
        ('ControlAccount',  'credit'),
        ('ControlAccount',  'debit'),
        ('LoanAccount',     'debit'),
        ('PayableAccount',  'debit'),
        ('CashAccount',     'debit'),
        ('HoldbackAccount', 'credit');
    }
  end
end
