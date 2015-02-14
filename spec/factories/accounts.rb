FactoryGirl.define do
  factory :account do
    # don't use :cash_account, it's not valid without an account_group_id
    # either a borrower or a lender
    factory :cash_account, class: Account::CustomerAccount::CashAccount do
      credit_or_debit "credit"

      factory :lender_cash_account do
        account_group factory: :lender
      end
    end

    factory :loan_account, class: Account::CustomerAccount::LoanAccount do
      credit_or_debit "debit"

      factory :borrower_loan_account do
        account_group factory: :borrower
      end
    end
  end
end
