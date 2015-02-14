require 'rails_helper'

RSpec.describe Account::CustomerAccount do
  let(:customer) { AccountGroup::Borrower.create }
  subject { build :cash_account }

  it "has to have an account group" do
    expect(subject).not_to be_valid
    subject.account_group = customer
    expect(subject).to be_valid
  end

  describe 'customer account uniqueness' do
    let(:another_account) { build :cash_account, account_group: customer }

    before do
      subject.account_group = customer
      subject.save
    end

    it 'cannot be duplicated' do
      expect(another_account).not_to be_valid
    end

    it 'cannot be duplicated at the db level' do
      expect{another_account.save validate: false}.to raise_error ActiveRecord::RecordNotUnique
    end

    context "with different account types" do
      let(:another_account) { build :loan_account, account_group: customer }

      before do
        subject.account_group = customer
        subject.save
      end

      it 'is valid' do
        expect(another_account).to be_valid
      end

      it 'succeeds at the db level' do
        expect{another_account.save validate: false}.not_to raise_error
      end
    end
  end
end
