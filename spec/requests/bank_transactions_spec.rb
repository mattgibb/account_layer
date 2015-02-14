require "rails_helper"

RSpec.describe "Bank Transactions" do
  let(:amount) { 123 }
  let(:id) { create(:bank_transaction, amount: amount).id }

  it_behaves_like "a viewable resource", :bank_transactions
  it_behaves_like "a read-only resource", :bank_transactions
  it_behaves_like "it is reconcilable", :bank_transactions do
    let(:our_account_id) { Account::LendlayerAccount::WellsFargoCash.first.id }
    let(:other_account_id) { create(:lender_cash_account).id }
  end
end
