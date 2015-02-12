require "rails_helper"

describe BankStatementLoader do
  let(:file_path) { Rails.root.join 'spec/fixtures/wells_fargo_statements/Checking2.qfx' }
  let(:admin) { create :admin }
  subject { described_class.new admin, file }

  shared_examples "a bank statement loader" do
    it "returns true" do
      expect(subject.load).to be true
    end

    it "records the file being loaded" do
      expect{subject.load}.to change{BankStatement.count}.by 1
    end

    it "saves the file contents" do
      subject.load
      expect(BankStatement.first.contents).to eq File.read file_path
    end

    it "extracts the account number" do
      subject.load
      expect(BankStatement.first.account_number).to eq 3665495713
    end

    it "creates the BankTransactions" do
      expect{subject.load}.to change{BankTransaction.count}.by 30
    end

    it "saves the BankTransaction details" do
      expect{subject.load}.to change{
        BankTransaction.where(
          transaction_type: 'POS',
          date_posted: Time.parse('2014-12-01 12:00:00'),
          amount: -20.50,
          transaction_id: 2014120111,
          name: 'Dr. Teeth and the',
          memo: 'CHECK CRD PURCHASE 11/29 SAN FRANCISCO CA 425907XXXXXX6993 304334247190364 ?MCC=5812'
        ).count
      }.by 1
    end

    context "reloading the same file" do
      before { described_class.new(admin, File.read(file_path)).load }

      it "returns false" do
        expect(subject.load).to be false
      end
    end
  end

  context "with a string" do
    let(:file) { File.read file_path }
    it_behaves_like "a bank statement loader"
  end

  context "with a stream" do
    let(:file) { File.new file_path }
    it_behaves_like "a bank statement loader"
  end
end
