require 'rails_helper'

RSpec.describe Account do
  let(:credit_account) { create :account }
  let(:debit_account)  { create :account }
  let(:amount) { 1234 }
  let(:transaction) { create :transaction,
                             credit_id: credit_account.id,
                             debit_id:  debit_account.id }

  describe "balances" do
    it "cannot be updated directly" do
      expect{credit_account.update_attribute :balance, amount}.to raise_error SomeException
    end

    it "are updated automatically when a transaction is added" do
      expect{transaction}.to change{credit_account.reload.balance}.to amount
      expect{transaction}.to change{debit_account.reload.balance }.to amount
    end

    it "are updated automatically when a transaction is modified" do
      delta = 321
      expect{transaction.update_attribute :amount, amount + delta}.to change{credit_account.reload.balance}.by amount
      expect{transaction.update_attribute :amount, amount + delta}.to change{debit_account.reload.balance }.by amount
    end

    it "are updated automatically when a transaction is modified" do
      expect{transaction.destroy}.to change{credit_account.reload.balance}.by -amount
      expect{transaction.destroy}.to change{debit_account.reload.balance }.by -amount
    end
  end
end
