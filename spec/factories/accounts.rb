FactoryGirl.define do
  factory :account do
    factory :credit_account do
      credit_or_debit "credit"
      name "Credit Account"
      type "ControlAccount"
    end

    factory :debit_account do
      credit_or_debit "debit"
      name "ControlAccount"
      type "ControlAccount"
    end
  end
end
