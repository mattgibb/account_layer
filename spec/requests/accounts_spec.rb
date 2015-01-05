require "rails_helper"

RSpec.describe "Transactions" do
  it_behaves_like "a resource"

  context "without logging in" do
    let(:id) { create(:transaction).id }

    it { get_json  "/transactions"; expect(response.code).to eq "401" }
    it { post_json "/transactions"; expect(response.code).to eq "401" }
  end

  # probably shouldn't allow deletes or updates?
  it { expect{put_json    "/transactions/#{id}"}.to raise_error }
  it { expect{delete_json "/transactions/#{id}"}.to raise_error }
end

