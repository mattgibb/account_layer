require 'rails_helper'

RSpec.describe BankTransaction do
  describe "#reconcile!" do
    subject { create :bank_transaction, amount: amount }

    let(:current_admin) { create :admin }
    let(:wells_fargo_account) { Account.wells_fargo_cash }

    def do_reconcile
      subject.reconcile! other_account_id, current_admin
    end

    context "a deposit" do
      let(:other_account_id) { create(:lender_with_accounts).cash_account.id }
      let(:amount) { 123 }

      before { do_reconcile }

      it "reconciles the transaction" do
        expect(Transaction.where credit_id: other_account_id,
                                 debit_id: wells_fargo_account.id,
                                 amount: amount).to exist
      end
    end

    context "a withdrawal" do
      let(:other_account_id) { create(:borrower_with_accounts).loan_account.id }
      let(:amount) { -123 }

      before do
        # put enough money in the Wells Fargo account beforehand
        create(:transaction, credit_id: create(:lender_cash_account).id,
                             debit_id: wells_fargo_account.id,
                             amount: 1000)
        do_reconcile
      end

      it "reconciles the transaction" do
        expect(Transaction.where credit_id: wells_fargo_account.id,
                                 debit_id: other_account_id,
                                 amount: -amount).to exist
      end
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
    subject { create :bank_transaction }

    let(:bank_reconciliation) do
      account = create(:lender_with_accounts).cash_account
      transaction = create :lendlayer_transaction, credit_account: account
      build :bank_reconciliation,
            transaction_id: transaction.id,
            bank_transaction_id: subject.id
    end

    it "is false without a bank reconciliation" do
      expect(subject).not_to be_reconciled
    end

    it "is false with a bank reconciliation that isn't persisted" do
      expect(subject).not_to be_reconciled
    end

    it "is true with a persisted reconciliation" do
      subject.reconciliation = bank_reconciliation
      subject.save
      expect(subject).to be_reconciled
    end
  end
end
