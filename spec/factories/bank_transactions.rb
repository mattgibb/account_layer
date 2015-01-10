FactoryGirl.define do
  factory :bank_transaction do
    bank_statement
    amount 123
  end
end
