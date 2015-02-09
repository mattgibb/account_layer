require "rails_helper"

RSpec.describe "Accounts" do
  let(:id) { create(:lender_cash_account).id }

  it_behaves_like "a viewable resource", :accounts

  # probably shouldn't allow creates, deletes or updates?
  it { expect{post_json   "/accounts"}.to       raise_error ActionController::RoutingError }
  it { expect{put_json    "/accounts/#{id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/accounts/#{id}"}.to raise_error ActionController::RoutingError }
end
