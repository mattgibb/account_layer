FactoryGirl.define do
  factory :transaction do
    amount 123
    paid_at Time.now
  end
end
