require "rails_helper"

RSpec.describe "Transactions" do
  it_behaves_like "a resource", :transactions
  let(:transaction_params) { {transaction: attributes_for(:transaction)} }

  context "without logging in" do
    it { get_json  "/transactions"; expect(response.code).to eq "401" }
    it { post_json "/transactions"; expect(response.code).to eq "401" }
  end

  context "when logged in" do
    before { login }

    describe "create" do
      before { byebug; post_json "/transactions", transaction_params } 

      it "is successful" do
        expect(response.code).to eq "201"
      end
    end
  end

  let(:id) { create(:transaction).id }

  # probably shouldn't allow deletes or updates?
  it { expect{put_json    "/transactions/#{id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/transactions/#{id}"}.to raise_error ActionController::RoutingError }
end

