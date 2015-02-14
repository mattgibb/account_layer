require 'rails_helper'

RSpec.describe FirstAssociatesTransaction do
  describe "#reconcile!" do
    subject { create :first_associates_transaction, payment_amount: amount }

    let(:current_admin) { create :admin }
    let(:other_account_id) { create(:borrower_with_accounts).cash_account.id }
    let(:amount) { 123 }

    def do_reconcile
      subject.reconcile! other_account_id, current_admin
    end

    it "reconciles the transaction" do
      do_reconcile
      expect(Transaction.where credit_id: other_account_id,
                               debit_id: Account.first_associates_receivables.id,
                               amount: amount).to exist
    end

    context "with an invalid account id" do
      let(:other_account_id) { 987654321 }
      let(:amount) { 123 }

      it "throws an error" do
        expect{do_reconcile}.to raise_error ActiveRecord::InvalidForeignKey
      end
    end
  end

  describe "#reconciled?" do
    subject { create :first_associates_transaction }

    let(:reconciliation) do
      account = create(:lender_with_accounts).cash_account
      transaction = create :lendlayer_transaction, credit_account: account
      build :first_associates_reconciliation,
            transaction_id: transaction.id,
            first_associates_transaction_id: subject.id
    end

    it "is false without a reconciliation" do
      expect(subject).not_to be_reconciled
    end

    it "is false with a reconciliation that isn't persisted" do
      expect(subject).not_to be_reconciled
    end

    it "is true with a persisted reconciliation" do
      subject.reconciliation = reconciliation
      subject.save
      expect(subject).to be_reconciled
    end
  end
end
