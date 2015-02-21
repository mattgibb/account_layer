require 'rails_helper'

RSpec.describe AccountGroup::Lender do
  subject { create :lender }

  describe "profiles" do
    it_behaves_like "it has a CustomerProfile"
  end

  describe '.create_with_profile_and_accounts' do
    it_behaves_like "it can create profiles and accounts"
  end
end
