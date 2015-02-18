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
          payment_method_reference: "123.0",
          principal: 123.45,
          interest: 12.34,
          fees: 1.23,
          late_charges: 0.12,
          udbs: 3.21,
          suspense: 43.21,
          impound: 543.21,
          payment_amount: 6543.21
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

  context "with a stream" do
    let(:file) { File.new file_path }
    it_behaves_like "a First Associates report loader"
  end
end
