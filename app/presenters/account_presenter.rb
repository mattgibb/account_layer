class AccountPresenter < BasePresenter
  def self.column_names
    Account.column_names + ['customer_name', 'customer_type'] - ['account_group_id', 'created_at', 'updated_at']
  end

  def customer_name
    profile.name if profile
  end

  def customer_type
    account_group.class.model_name.human if account_group
  end

  private

    def account_group
      @model.respond_to? :account_group and @model.account_group
    end

    def profile
      account_group.respond_to? :profile and account_group.profile
    end
end
