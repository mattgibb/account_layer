require "rails_helper"

describe FirstAssociatesReportLoader do
  let(:file_path) { Rails.root.join 'spec/fixtures/Sample Loan Report Pack.xlsx' }
  let(:admin) { create :admin }
  subject { described_class.new admin, file }

  shared_examples "a First Associates report loader" do
    it "returns true" do
      expect(subject.load).to be true
    end

    it "records the file being loaded" do
      expect{subject.load}.to change{FirstAssociatesReport.count}.by 1
    end

    it "saves the file contents" do
      subject.load
      expect(FirstAssociatesReport.first.contents).to eq File.read(file_path).b
    end

    it "creates the FirstAssociatesTransactions" do
      expect{subject.load}.to change{
        FirstAssociatesTransaction.where(
          transaction_date: Date.new(2013,9,4),
          effective_date:   Date.new(2013,9,5),
          g_l_date:         Date.new(2013,9,6),
          loan_number: 50,
          short_name: "An FA Transaction",
          payment_method: 'ACH',
          payment_method_reference: "123.0"
        ).where("
          round(principal,      4)=123.45 AND
          round(interest,       4)=12.34 AND
          round(fees,           4)=1.23 AND
          round(late_charges,   4)=0.12 AND
          round(udbs,           4)=3.21 AND
          round(suspense,       4)=43.21 AND
          round(impound,        4)=543.21 AND
          round(payment_amount, 4)=6543.21
        ").count
      }.by 1
    end

    context "reloading the same file" do
      before { described_class.new(admin, File.read(file_path)).load }

      it "returns false" do
        expect(subject.load).to be false
      end
    end
  end

  context "with a stream" do
    let(:file) { File.new file_path }
    it_behaves_like "a First Associates report loader"
  end
end
