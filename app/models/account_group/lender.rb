class AccountGroup::Lender < AccountGroup
  has_one :cash_account, class_name: 'Account::CustomerAccount::CashAccount', foreign_key: :account_group_id
  has_one :profile,
           -> { where account_group_type: 'AccountGroup::Lender' },
          class: CustomerProfile,
          foreign_key: :account_group_id,
          foreign_type: :account_group_type
end
