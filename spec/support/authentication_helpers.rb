ENV['JWT_SECRET'] ||= 'secret'
ENV['API_TOKEN'] ||= 'api_token'

module AuthenticationHelpers
  def auth_header
    {'Authorization' => "Bearer #{token}"}
  end

  def api_auth_header
    {'Authorization' => "Token #{api_token}"}
  end

  private
    def token
      JWT.encode user_info, ENV['JWT_SECRET']
    end

    def api_token
      ENV['API_TOKEN']
    end

    def user_info
      @user_info ||= create(:admin).as_json.slice 'email', 'name'
    end
end
