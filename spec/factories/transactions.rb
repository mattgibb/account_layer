FactoryGirl.define do
  factory :transaction do
    amount 123
    paid_at Time.now
    due_at Time.now + 1.hour

    factory :lendlayer_transaction do
      association :credit_account, factory: :lender_cash_account
      debit_id Account::LendlayerAccount::WellsFargoCash.first.id
    end
  end
end
