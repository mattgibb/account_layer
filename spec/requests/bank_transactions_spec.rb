require "rails_helper"

RSpec.describe "Bank Transactions" do
  let(:id) { create(:bank_transaction).id }

  it_behaves_like "a viewable resource", :bank_transactions

  # don't allow creates, updates or deletes
  it { expect{post_json   "/bank_transactions"}.to       raise_error ActionController::RoutingError }
  it { expect{put_json    "/bank_transactions/#{id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/bank_transactions/#{id}"}.to raise_error ActionController::RoutingError }
end


