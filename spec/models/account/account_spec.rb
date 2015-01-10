require 'rails_helper'

RSpec.describe Account do
  let(:credit_account)  { create :lender_cash_account }
  let(:debit_account) { Account::LendlayerAccount::WellsFargoCash.first }
  let(:amount) { 123 }
  let!(:transaction) { create :transaction,
                             credit_id: credit_account.id,
                             debit_id:  debit_account.id }

  describe "balances" do
    it "are updated automatically when a transaction is added" do
      expect(credit_account.reload.balance).to eq amount
      expect(debit_account.reload.balance ).to eq amount
    end

    it "are updated automatically when a transaction is modified" do
      delta = 321
      transaction.update_attribute :amount, amount + delta
      expect(credit_account.reload.balance).to eq amount + delta
      expect(debit_account.reload.balance).to eq amount + delta
    end

    it "are updated automatically when a transaction is deleted" do
      transaction.destroy
      expect(credit_account.reload.balance).to be_zero
      expect(debit_account.reload.balance ).to be_zero
    end
  end
end
