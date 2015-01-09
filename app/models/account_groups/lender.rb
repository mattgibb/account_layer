class Lender < AccountGroup
  has_one :cash_account
  has_one :profile,
           -> { where account_group_type: 'Lender' },
          class: CustomerProfile,
          foreign_key: :account_group_id,
          foreign_type: :account_group_type
end
