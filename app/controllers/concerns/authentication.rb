module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    if valid_keycloak_token?
      true
    else
      redirect_to sign_in_path, allow_other_host: false
    end
  end

  def valid_keycloak_token?
    cookie = cookies[:keycloak_token]
    return false unless cookie.present?

    begin
      decoded_cookie = URI.decode_www_form_component(cookie)
      token_data = JSON.parse(decoded_cookie)
      access_token = token_data["AccessToken"]
      return false unless access_token

      payload = JWT.decode(access_token, nil, false).first
      exp = payload["exp"]

      # For the view ========================
      @sub = payload["sub"]
      @first_name = payload["given_name"]
      # =====================================

      return false if exp && Time.at(exp) < Time.now

      jwks = fetch_jwks
      JWT.decode(access_token, nil, true, {
        algorithms: [ "RS256" ],
        jwks: jwks
      })

      true
    rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature, JSON::ParserError
      false
    end
  end

  def fetch_jwks
    jwks_url = "http://keycloak:8080/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/certs"
    response = Faraday.get(jwks_url)
    JSON.parse(response.body)
  end
end
