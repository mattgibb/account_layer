require 'rails_helper'

RSpec.describe "LendLayer internal accounts" do
  describe 'control account uniqueness' do
    it 'cannot be duplicated' do
      create_account = -> {
        Account::LendlayerAccount::WellsFargoCash.create credit_or_debit: "debit"
      }
      expect{create_account.call}.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end
