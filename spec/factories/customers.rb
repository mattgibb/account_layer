FactoryGirl.define do
  factory :account_group do
    factory :borrower do
    end

    factory :lender, class: Lender do
      # after(:create) do |lender|
      #   create :lender_cash_account, customer_id: lender.id
      # end
    end

    factory :school do
    end

    factory :cohort do
    end
  end
end
