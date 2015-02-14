RSpec.shared_examples "it is reconcilable" do |resource|
  let(:resource) { resource } # puts 'resource' in helper method scope

  context "reconciling transactions" do
    def do_post(headers=nil)
      post_json "/#{resource}/#{id}/reconciliation",
                {account_id: other_account_id},
                headers
    end

    context "when logged in" do
      before { do_post auth_header }

      it "is successful" do
        expect(response.code).to eq "201"
      end

      it "creates a transaction from a lender's account to our account" do
        query = Transaction.where(credit_id: other_account_id,
                                  debit_id: our_account_id,
                                  amount: amount,
                                  due_at: nil)
                           .where.not(paid_at: nil)
        expect(query).to exist
      end

      context "with an invalid account id" do
        let(:other_account_id) { 987654321 }

        it "returns 404 not found" do
          do_post auth_header
          expect(response.code).to eq "404"
        end
      end
    end

    context "without logging in" do
      specify { do_post; expect(response.code).to eq "401" }
    end
  end
end
