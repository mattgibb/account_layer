require 'rails_helper'

describe "API::Schools" do
  it_behaves_like "a customer resource", "school"
end
