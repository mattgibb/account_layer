module JSONHelpers
  %i[get post put delete].each do |verb|
    define_method "#{verb}_json" do |url|
      send verb, url, format: :json
    end
  end

  def json
    JSON.parse response.body
  end
end
