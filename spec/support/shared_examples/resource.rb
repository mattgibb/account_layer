RSpec.shared_examples "a resource" do |resource|
  context "when logged in" do
    before { login }

    describe "index" do
      before { get_json "/#{resource}" }

      it "is successful" do
        expect(response.code).to eq "200"
      end

      it "includes the #{resource}" do
        expect(json).to include "models" 
        expect(json["models"]).to be_a Array
      end

      it "includes the field names" do
        expect(json).to include "attributes" 
      end
    end

    describe "show" do
      before { get_json "/#{resource}/#{id}" }
    end
  end
end
