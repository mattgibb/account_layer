module AuthenticationHelpers
  # turn off actual OAuth
  OmniAuth.config.test_mode = true

  def login
    sign_up
    https!
    get_via_redirect "/auth/google_apps_oauth2"
    https! false
  end

  private

    def sign_up
      info = {email: 'ronnybaby@lendlayer.com', name: 'Ronny Baby'}

      OmniAuth.config.add_mock :google_apps_oauth2, info: info
      Admin.find_or_create_by info
    end
end
