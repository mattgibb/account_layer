require 'rails_helper'

describe AccountGroup::Borrower do
  subject { create :borrower }

  describe "profiles" do
    it_behaves_like "it has a CustomerProfile"
  end

  describe '.create_with_profile_and_accounts' do
    it_behaves_like "it can create profiles and accounts" do
      it "creates a loan account" do
        expect(subject.loan_account).to be_persisted
      end
    end
  end
end
