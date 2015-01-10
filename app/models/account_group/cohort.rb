class AccountGroup::Cohort < AccountGroup
  has_one :profile,
           -> { where account_group_type: 'AccountGroup::Cohort' },
          class: CohortProfile,
          foreign_key: :account_group_id,
          foreign_type: :account_group_type
end
