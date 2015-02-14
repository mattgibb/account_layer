class AccountGroup::Borrower < AccountGroup
  has_one :loan_account, class_name: 'Account::CustomerAccount::LoanAccount', foreign_key: :account_group_id
  has_one :cash_account, class_name: 'Account::CustomerAccount::CashAccount', foreign_key: :account_group_id
  has_one :profile,
           -> { where account_group_type: 'AccountGroup::Borrower' },
          class: CustomerProfile,
          foreign_key: :account_group_id,
          foreign_type: :account_group_type
end
