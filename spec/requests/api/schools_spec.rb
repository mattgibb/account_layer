require 'rails_helper'

RSpec.describe "API::Schools" do
  describe "POST /api/schools" do
    let(:school_params) { {name: 'Jimbo School of Dev', lendlayer_id: 321} }

    def do_post
      post_json api_schools_path, {school: school_params}, auth_headers
    end

    context "with token" do
      let(:auth_headers) { api_auth_header }

      it "responds that the school is created" do
        do_post
        expect(response).to have_http_status(204)
        expect(response.location).to match /\/api\/schools\/\d+$/
      end

      it "creates a school" do
        expect{do_post}.to change{AccountGroup::School.count}.by 1
      end

      context "when the schoool already exists" do
        it "responds that the school already exists" do
          2.times {do_post}
          expect(response).to have_http_status(200)
        end

        it "only creates one school" do
          expect{2.times {do_post}}.to change{AccountGroup::School.count}.by 1
        end
      end

      context "with invalid school params" do
        let(:school_params) { {some: 'params'} }

        it "responds with unprocessable entity" do
          do_post
          expect(response).to have_http_status 422
        end

        it "doesn't create a school" do
          expect{do_post}.not_to change{AccountGroup::School.count}
        end
      end
    end

    context "without token" do
      let(:auth_headers) { {} }

      it "is unauthorized" do
        do_post
        expect(response).to have_http_status(401)
      end
    end
  end
end
