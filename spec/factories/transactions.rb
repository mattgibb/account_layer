FactoryGirl.define do
  factory :transaction do
    amount 123
    paid_at Time.now

    factory :lendlayer_transaction do
      association :credit_account, factory: :lender_cash_account
      # debit_id in block so that rake db:setup doesn't access the db
      # before it's created when FactoryGirl loads
      debit_id { Account.wells_fargo_cash.id } 
    end
  end
end
