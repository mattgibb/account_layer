FactoryGirl.define do
  factory :admin do
    name {|n| "Admin #{n}" }
    email {|n| "admin#{n}@lendlayer.com" }
  end
end
