FactoryGirl.define do
  factory :account do
    factory :lender_cash_account, class: Account::CustomerAccount::CashAccount do
      credit_or_debit "credit"
    end
  end
end
