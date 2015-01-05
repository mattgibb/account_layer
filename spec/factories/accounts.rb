FactoryGirl.define do
  factory :account do

    factory :credit_account do
      credit_or_debit "credit"
      name "Credit Account"
    end

    factory :debit_account do
      credit_or_debit "debit"
      name "Debit Account"
    end
  end
end
