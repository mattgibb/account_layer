require 'rails_helper'

RSpec.describe "API::Lenders" do
  it_behaves_like "a customer resource", "lender"
end
