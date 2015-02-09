require "rails_helper"

RSpec.describe "Transactions" do
  let(:transaction) { create(:lendlayer_transaction) }
  let(:id) { transaction.id }

  it_behaves_like "a viewable resource", :transactions

  context "when logged in" do
    describe "create" do
      let(:debit_id)  { Account::LendlayerAccount::WellsFargoCash.first.id }
      let(:credit_id) { create(:lender_cash_account).id }
      let(:transaction_params) { {transaction: attributes_for(:transaction, credit_id: credit_id, debit_id: debit_id)} }

      before { post_json "/transactions", transaction_params, auth_header }

      it "is successful" do
        expect(response.code).to eq "201"
      end
    end
  end

  context "without logging in" do
    describe "create" do
      specify { post_json "/transactions"; expect(response.code).to eq "401" }
    end
  end

  # probably shouldn't allow deletes or updates?
  it { expect{put_json    "/transactions/#{id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/transactions/#{id}"}.to raise_error ActionController::RoutingError }
end
