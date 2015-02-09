FactoryGirl.define do
  factory :admin do
    sequence(:name) {|n| "Admin #{n}" }
    sequence(:email) {|n| "admin#{n}@lendlayer.com" }
  end
end
