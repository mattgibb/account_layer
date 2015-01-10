require "rails_helper"

RSpec.describe "Bank Transactions" do
  let(:amount) { 123 }
  let(:bank_transaction) { create(:bank_transaction, amount: amount) }

  it_behaves_like "a viewable resource", :bank_transactions do
    let(:id) { bank_transaction.id }
  end

  # don't allow creates, updates or deletes
  it { expect{post_json   "/bank_transactions"                       }.to raise_error ActionController::RoutingError }
  it { expect{put_json    "/bank_transactions/#{bank_transaction.id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/bank_transactions/#{bank_transaction.id}"}.to raise_error ActionController::RoutingError }

  context "reconciling transactions" do
    let(:wells_fargo_cash) { Account::LendlayerAccount::WellsFargoCash.first }
    let(:other_account_id) { create(:lender_cash_account).id }

    def do_post
      post_json "/bank_transactions/#{bank_transaction.id}/reconciliation",
                account_id: other_account_id
    end

    context "when logged in" do
      before { login; do_post }

      it "is successful" do
        expect(response.code).to eq "201"
      end

      it "creates a transaction from a lender's account to our cash account" do
        query = Transaction.where(credit_id: other_account_id,
                                  debit_id: wells_fargo_cash.id,
                                  amount: bank_transaction.amount,
                                  due_at: nil)
                           .where.not(paid_at: nil)
        expect(query).to exist
      end

      context "with an invalid account id" do
        let(:other_account_id) { 987654321 }

        it "returns 404 not found" do
          do_post
          expect(response.code).to eq "404"
        end
      end
    end

    context "without logging in" do
      specify { do_post; expect(response.code).to eq "401" }
    end
  end
end


