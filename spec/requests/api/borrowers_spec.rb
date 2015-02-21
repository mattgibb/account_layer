require 'rails_helper'

describe "API::Borrowers" do
  it_behaves_like "a customer resource", "borrower"
end
