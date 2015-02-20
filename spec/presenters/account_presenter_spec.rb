require 'rails_helper'

describe AccountPresenter do
  subject { described_class.new account, nil }

  context "presenting LendLayer accounts" do
    let(:account) { Account.wells_fargo_cash }

    its(:customer_name) { should be_nil }
    its(:customer_type) { should be_nil }
  end

  context "presenting customer accounts" do
    let(:lender_name) { 'Ben Gilbert' }
    let(:account) do
      lender = create :lender_with_accounts
      lender.create_profile name: lender_name, lendlayer_id: 1
      lender.cash_account
    end

    its(:customer_name) { should eq lender_name }
    its(:customer_type) { should eq "Lender" }
  end
end
