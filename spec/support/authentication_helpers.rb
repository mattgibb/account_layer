ENV['JWT_SECRET'] ||= 'secret'

module AuthenticationHelpers
  def auth_header
    {'Authorization' => "Bearer #{token}"}
  end

  private
    def token
      JWT.encode user_info, ENV['JWT_SECRET']
    end

    def user_info
      @user_info ||= create(:admin).as_json.slice 'email', 'name'
    end
end
