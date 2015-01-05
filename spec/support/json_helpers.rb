module JSONHelpers
  def get_json(url)
    get url, format: :json
  end

  def json
    JSON.parse response.body
  end
end
