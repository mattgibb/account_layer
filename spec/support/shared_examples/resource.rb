RSpec.shared_examples "a resource" do
  context "when logged in" do
    before { login }

    describe "index" do
      before { get_json '/transactions' }

      it "is successful" do
        expect(response.code).to eq "200"
      end

      it "includes the transactions" do
        expect(json).to include "models" 
        expect(json["models"]).to be_a Array
      end

      it "includes the field names" do
        expect(json).to include "attributes" 
      end
    end
  end

end
