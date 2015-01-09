require 'rails_helper'

RSpec.describe Lender do
  subject! { create :lender }

  describe "profiles" do
    def create_customer_profile
      subject.create_profile
    end

    it "can have a CustomerProfile" do
      create_customer_profile
      expect(lender.profile.exists?).to be true
    end

    it "cannot have two CustomerProfiles" do
      create_customer_profile
      expect{create_customer_profile}.to raise_error
    end

    it "cannot have a CohortProfile" do
    end
  end
end
