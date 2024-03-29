require 'omniauth/strategies/oauth2'

class GoogleAppsOauth2 < OmniAuth::Strategies::OAuth2
  BASE_SCOPE_URL = "https://www.googleapis.com/auth/"
  BASE_SCOPES = %w[profile email openid]
  DEFAULT_SCOPE = "email,profile"

  option :name, 'google_apps_oauth2'

  option :authorize_options, [:access_type, :hd, :login_hint, :prompt, :request_visible_actions, :scope, :state, :redirect_uri, :include_granted_scopes]

  option :client_options, {
    :site          => 'https://accounts.google.com',
    :authorize_url => '/o/oauth2/auth',
    :token_url     => '/o/oauth2/token'
  }

  def authorize_params
    super.tap do |params|
      options[:authorize_options].each do |k|
        params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
      end

      raw_scope = params[:scope] || DEFAULT_SCOPE
      scope_list = raw_scope.split(" ").map {|item| item.split(",")}.flatten
      scope_list.map! { |s| s =~ /^https?:\/\// || BASE_SCOPES.include?(s) ? s : "#{BASE_SCOPE_URL}#{s}" }
      params[:scope] = scope_list.join(" ")
      params[:access_type] = 'offline' if params[:access_type].nil?

      session['omniauth.state'] = params[:state] if params['state']
    end
  end

  uid { raw_info['sub'] || verified_email }

  info do
    prune!({
      name:  raw_info['displayName'],
      email: raw_info['emails'].first['value']
    })
  end

  extra do
    hash = {}
    hash[:id_token] = access_token['id_token']
    hash[:raw_info] = raw_info unless skip_info?
    prune! hash
  end

  def raw_info
    @raw_info ||= access_token.get('https://www.googleapis.com/plus/v1/people/me').parsed
  end

  def custom_build_access_token
    if request.xhr? && request.params['code']
      verifier = request.params['code']
      client.auth_code.get_token(verifier, { :redirect_uri => 'postmessage'}.merge(token_params.to_hash(:symbolize_keys => true)),
                                 deep_symbolize(options.auth_token_params || {}))
    elsif verify_token(request.params['id_token'], request.params['access_token'])
      ::OAuth2::AccessToken.from_hash(client, request.params.dup)
    else
      orig_build_access_token
    end
  end
  alias_method :orig_build_access_token, :build_access_token
  alias_method :build_access_token, :custom_build_access_token

  private

  def prune!(hash)
    hash.delete_if do |_, v|
      prune!(v) if v.is_a?(Hash)
      v.nil? || (v.respond_to?(:empty?) && v.empty?)
    end
  end

  def verified_email
    raw_info['email_verified'] ? raw_info['email'] : nil
  end

  def verify_token(id_token, access_token)
    return false unless (id_token && access_token)

    raw_response = client.request(:get, 'https://www.googleapis.com/oauth2/v2/tokeninfo', :params => {
      :id_token => id_token,
      :access_token => access_token
    }).parsed
    raw_response['issued_to'] == options.client_id
  end
end
