FactoryGirl.define do
  factory :customer_profile do
    sequence(:lendlayer_id) {|n| n.to_i }
    sequence(:name) {|n| "John Doe #{n}"}
  end
end

