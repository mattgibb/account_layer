class AccountGroup::School < AccountGroup
  has_one :cash_account, class_name: 'Account::CustomerAccount::CashAccount', foreign_key: :account_group_id
  has_one :profile,
           -> { where account_group_type: 'AccountGroup::School' },
          class: CustomerProfile,
          foreign_key: :account_group_id,
          foreign_type: :account_group_type

  def self.create_with_profile_and_accounts(profile_params)
    begin
      transaction do
        create.tap do |school|
          school.create_cash_account!
          school.create_profile! profile_params
        end
      end
    rescue ActiveRecord::RecordInvalid
    end
  end
end
