require "rails_helper"

RSpec.describe "Accounts" do
  it_behaves_like "a resource", :accounts

  let(:id) { create(:transaction).id }

  context "without logging in" do
    specify { get_json  "/accounts"; expect(response.code).to eq "401" }
    specify { get_json  "/accounts/#{id}"; expect(response.code).to eq "401" }
  end

  # probably shouldn't allow creates, deletes or updates?
  it { expect{post_json   "/accounts"}.to       raise_error ActionController::RoutingError }
  it { expect{put_json    "/accounts/#{id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/accounts/#{id}"}.to raise_error ActionController::RoutingError }
end

