class AccountGroup::Borrower < AccountGroup
  has_one :loan_account, class_name: 'Account::CustomerAccount::LoanAccount', foreign_key: :account_group_id
  has_one :cash_account, class_name: 'Account::CustomerAccount::CashAccount', foreign_key: :account_group_id
  has_one :profile,
           -> { where account_group_type: 'AccountGroup::Borrower' },
          class: CustomerProfile,
          foreign_key: :account_group_id,
          foreign_type: :account_group_type

  def self.create_with_profile_and_accounts(profile_params)
    begin
      transaction do
        create.tap do |lender|
          lender.create_loan_account!
          lender.create_cash_account!
          lender.create_profile! profile_params
        end
      end
    rescue ActiveRecord::RecordInvalid
    end
  end
end
