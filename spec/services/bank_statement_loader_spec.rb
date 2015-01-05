require "rails_helper"

describe BankStatementLoader do
  let(:file_string) { File.read Rails.root.join 'spec/fixtures/wells_fargo_statements/Checking2.qfx' }
  let(:admin) { create :admin }

  subject { described_class.new admin, file_string }

  it "records the file being loaded" do
    expect{subject.load}.to change{BankStatement.count}.by 1
  end

  it "saves the file contents" do
    subject.load
    expect(BankStatement.first.contents).to eq file_string
  end
end
