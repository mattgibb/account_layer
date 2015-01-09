require 'rails_helper'

RSpec.describe "LendLayer internal accounts" do
  describe 'control account uniqueness' do
    it 'cannot be duplicated' do
      create_account = -> {
        WellsFargoCash.create credit_or_debit: "debit"
      }
      create_account.call
      expect{create_account.call}.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end

