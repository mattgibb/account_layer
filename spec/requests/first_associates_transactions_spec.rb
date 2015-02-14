require "rails_helper"

RSpec.describe "First Associates Transactions" do
  let(:amount) { 123 }
  let(:id) { create(:first_associates_transaction, amount: amount).id }

  it_behaves_like "a viewable resource", :first_associates_transactions
  it_behaves_like "a read-only resource", :first_associates_transactions
  it_behaves_like "it is reconcilable", :first_associates_transactions do
    let(:our_account_id) { Account::LendlayerAccount::FirstAssociatesReceivables.first.id }
    let(:other_account_id) { create(:borrower_cash_account).id }
  end
end
