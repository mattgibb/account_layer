FactoryGirl.define do
  factory :account do
    factory :credit_account do
      credit_or_debit "credit"
      name "Credit Account"
      type "ControlAccount"
      belongs_to_customer false
    end

    factory :debit_account do
      credit_or_debit "debit"
      name "Cash Account"
      type "ControlAccount"
      belongs_to_customer false
    end

    factory :lender_cash_account do
      credit_or_debit "credit"
      name "Lender Cash Account"
      type "LenderCashAccount"
      belongs_to_customer true
    end
  end
end
