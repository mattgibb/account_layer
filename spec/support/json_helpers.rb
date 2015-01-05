module JSONHelpers
  %i[get post put delete].each do |verb|
    define_method "#{verb}_json" do |path, parameters={}, headers_or_env=nil|
      send verb, path, parameters.reverse_merge!(format: :json), headers_or_env
    end
  end

  def json
    JSON.parse response.body
  end
end
