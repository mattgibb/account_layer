class Account::CustomerAccount < Account
  belongs_to :account_group

  validates_presence_of   :account_group_id
  validates_uniqueness_of :account_group_id, scope: :type
end
