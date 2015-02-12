FactoryGirl.define do
  factory :transaction do
    amount 123
    paid_at Time.now
    due_at Time.now + 1.hour

    factory :lendlayer_transaction do
      association :credit_account, factory: :lender_cash_account
      cash_account = Account::LendlayerAccount::WellsFargoCash.first
      debit_id cash_account && cash_account.id
    end
  end
end
