require 'rails_helper'

RSpec.describe BankTransaction, :type => :model do
  let(:reconciliation) { create :lendlayer_transaction }
  subject { create :bank_transaction }

  describe "#reconciled?" do
    it "is false without a reconciliation" do
      expect(subject).not_to be_reconciled
    end

    it "is true with a persisted reconciliation" do
      subject.reconciliation = reconciliation
      subject.save
      expect(subject).to be_reconciled
    end
  end
end
