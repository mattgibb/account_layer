require "rails_helper"

RSpec.describe "Uploading bank statements" do
  let(:upload_path) { '/bank_statements' }

  def do_post
    path = Rails.root.join 'spec/fixtures/wells_fargo_statements/Checking2.qfx'
    qfx_file = Rack::Test::UploadedFile.new path, 'application/vnd.intu.qfx'
    statement_params = {file: qfx_file}
    post upload_path, statement_params, extra_headers
  end

  context "without logging in" do
    let(:extra_headers) {{}}

    it { do_post; expect(response.code).to eq "401" }
  end

  context "when logged in" do
    let(:extra_headers) { auth_header }

    before { do_post }

    it "creates the resource" do
      expect(BankStatement.count).to eq 1
    end

    it "says it's been created" do
      expect(response.code).to eq "201"
    end

    context "when it has already been uploaded" do
      it "says it is a success" do
        do_post # again
        expect(response.code).to eq "200"
      end

      it "doesn't create another resource" do
        expect{do_post}.not_to change{BankStatement.count}
      end
    end

    context "without a file attached" do
      it "replies with 'unprocessable entity'" do
        post upload_path, {}, auth_header
        expect(response.code).to eq "422"
      end
    end
  end
end
