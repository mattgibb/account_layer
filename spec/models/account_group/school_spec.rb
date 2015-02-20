require 'rails_helper'

describe AccountGroup::School do
  describe "profiles" do
    subject { create :school }

    def create_customer_profile
      subject.create_profile attributes_for :customer_profile
    end

    def create_cohort_profile
      create :cohort_profile, account_group_id: subject.id, account_group_type: subject.type
    end

    it "can have a CustomerProfile" do
      create_customer_profile
      expect(subject.profile.nil?).to be false
    end

    it "cannot have two CustomerProfiles" do
      create_customer_profile
      expect{create_customer_profile}.to raise_error ActiveRecord::RecordNotUnique
    end

    it "cannot have a CohortProfile" do
      expect{create_cohort_profile}.to raise_error ActiveRecord::StatementInvalid
    end
  end

  describe '.create_with_profile_and_accounts' do
    let(:params) { {name: 'NYCDA', lendlayer_id: 123} }
    let(:profile) { CustomerProfile.where }
    subject { described_class.create_with_profile_and_accounts params }

    it "creates a school, a profile and cash account" do
      expect(subject).to be_persisted
      expect(subject.cash_account).to be_persisted
      expect(CustomerProfile.where(params.merge(
          account_group_id: subject.id,
          account_group_type: 'AccountGroup::School'
      ))).to exist
    end

    context 'with invalid params' do
      let(:params) { {} }

      def try_to_create_school
        begin
          subject
        rescue ActiveRecord::StatementInvalid
        end
      end

      it "doesn't create anything" do
        expect{try_to_create_school}.not_to change {described_class.count}
        expect{try_to_create_school}.not_to change {CustomerProfile.count}
        expect{try_to_create_school}.not_to change {Account.count}
      end
    end
  end
end
