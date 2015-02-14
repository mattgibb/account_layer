RSpec.shared_examples "a read-only resource" do |resource|
  it { expect{post_json   "/#{resource}"      }.to raise_error ActionController::RoutingError }
  it { expect{put_json    "/#{resource}/#{id}"}.to raise_error ActionController::RoutingError }
  it { expect{delete_json "/#{resource}/#{id}"}.to raise_error ActionController::RoutingError }
end
