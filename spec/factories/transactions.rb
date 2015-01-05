FactoryGirl.define do
  factory :transaction do
    amount 123
    paid_at Time.now
    due_at Time.now + 1.hour
    credit_account
    debit_account
  end
end
