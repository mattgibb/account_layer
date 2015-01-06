RSpec.shared_examples "a viewable resource" do |resource|
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

      it "replies with a #{resource.to_s.singularize}" do
        expect(json["id"]).to eq id
      end
    end
  end

  context "without logging in" do
    specify { get_json "/#{resource}"; expect(response.code).to eq "401" }
    specify { get_json "/#{resource}/#{id}"; expect(response.code).to eq "401" }
  end

end
