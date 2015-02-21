shared_examples "a customer resource" do |resource|
  let(:resource) { resource }
  
  describe "POST /api/#{resource.pluralize}" do
    let(:klass) { "AccountGroup::#{resource.capitalize}".constantize }

    let(:resource_params) { {name: 'An account group of some sort', lendlayer_id: 321} }

    def do_post
      path = send "api_#{resource.pluralize}_path"
      post_json path, {resource => resource_params}, auth_headers
    end

    context "with token" do
      let(:auth_headers) { api_auth_header }

      it "responds that the #{resource} is created" do
        do_post
        expect(response).to have_http_status(204)
        expect(response.location).to match /\/api\/#{resource.pluralize}\/\d+$/
      end

      it "creates a #{resource}" do
        expect{do_post}.to change{klass.count}.by 1
      end

      context "when the #{resource} already exists" do
        it "responds that it already exists" do
          2.times {do_post}
          expect(response).to have_http_status(200)
        end

        it "only creates one #{resource}" do
          expect{2.times {do_post}}.to change{klass.count}.by 1
        end
      end

      context "with invalid #{resource} params" do
        let(:resource_params) { {some: 'params'} }

        it "responds with unprocessable entity" do
          do_post
          expect(response).to have_http_status 422
        end

        it "doesn't create a #{resource}" do
          expect{do_post}.not_to change{klass.count}
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
