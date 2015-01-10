FactoryGirl.define do
  factory :account_group do
    factory :borrower, class: AccountGroup::Borrower do
      association :loan_account, factory: :borrower_loan_account
    end

    factory :lender, class: AccountGroup::Lender do
      association :cash_account,
                  factory: :lender_cash_account
    end

    factory :school do
    end

    factory :cohort do
    end
  end
end
