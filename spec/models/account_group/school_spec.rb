require 'rails_helper'

describe AccountGroup::School do
  describe "profiles" do
    subject { create :school }

    it_behaves_like "it has a CustomerProfile"
  end

  describe '.create_with_profile_and_accounts' do
    it_behaves_like "it can create profiles and accounts"
  end
end
