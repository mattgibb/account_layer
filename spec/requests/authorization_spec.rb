require "rails_helper"

RSpec.describe "Authorization" do
  let(:exp) { Time.now.to_i + 5.seconds }
  let!(:payload) { create(:admin).as_json.slice('email', 'name').merge exp: exp }
  let(:token) { JWT.encode payload, ENV['JWT_SECRET'] }
  let(:auth_header) { {'Authorization' => "Bearer #{token}"} }

  subject { response }

  before { get_json "/accounts", {}, auth_header }

  describe "valid token" do
    it { is_expected.to be_successful }
  end

  describe "token without a preregistered email address" do
    let(:payload) { {some: :hash} }
    it { is_expected.to be_unauthorized }
  end

  describe "no token" do
    let(:auth_header) { nil }
    it { is_expected.to be_unauthorized }
  end

  describe "expired token" do
    let(:exp) { Time.now.to_i - 5.seconds }
    it { is_expected.to be_unauthorized }
  end

  describe "invalid tokens" do
    let(:token) { "invalid" }
    it { is_expected.to be_unauthorized }
  end
end
