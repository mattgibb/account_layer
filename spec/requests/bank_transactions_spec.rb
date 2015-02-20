require "rails_helper"

RSpec.describe "Bank Transactions" do
  let(:amount) { 123 }
  let(:id) { create(:bank_transaction, amount: amount).id }
  let(:other_account_id) { create(:lender_cash_account).id }

  it_behaves_like "a viewable resource", :bank_transactions
  it_behaves_like "a read-only resource", :bank_transactions
  it_behaves_like "it is reconcilable", :bank_transactions do
    let(:our_account_id) { Account::LendlayerAccount::WellsFargoCash.first.id }
  end

  context "with insufficient funds in the account" do
    let(:amount) { -123 }

    it "returns 422 unprocessable entity" do
      post_json "/bank_transactions/#{id}/reconciliation",
                {account_id: other_account_id},
                auth_header
      expect(response.code).to eq "422"
    end
  end
end
