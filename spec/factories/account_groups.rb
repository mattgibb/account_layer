FactoryGirl.define do
  factory :account_group do
    factory :borrower, class: AccountGroup::Borrower do |b|
      factory :borrower_with_accounts do
        after(:create) do |borrower|
          create :cash_account, account_group_id: borrower.id
          create :loan_account, account_group_id: borrower.id
        end
      end
    end

    factory :lender, class: AccountGroup::Lender do
      factory :lender_with_accounts do
        after(:create) {|lender| create :cash_account, account_group_id: lender.id }
      end
    end

    factory :school do
    end

    factory :cohort do
    end
  end
end
