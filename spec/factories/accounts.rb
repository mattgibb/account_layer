FactoryGirl.define do
  factory :account do
    factory :lender_cash_account, class: Account::CustomerAccount::CashAccount do
      credit_or_debit "credit"
    end

    factory :borrower_loan_account, class: Account::CustomerAccount::LoanAccount do
      credit_or_debit "debit"
    end
  end
end
