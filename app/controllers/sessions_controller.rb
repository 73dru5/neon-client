class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  def new
    state = SecureRandom.hex(16)
    session["omniauth.state"] = state

    base_url = "http://localhost:9000/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/auth"

    query_params = {
      client_id: ENV["KEYCLOAK_CLIENT_ID"],
      redirect_uri: ENV["KEYCLOAK_REDIRECT_URI"],
      response_type: "code",
      scope: "openid profile email",
      state: state,
      ref: "foo"
  }.to_query

    redirect_to "#{base_url}?#{query_params}", allow_other_host: true
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth
      token_data = {
        AccessToken: auth.credentials.token,
        RefreshToken: auth.credentials.refresh_token
      }
      encoded_token = URI.encode_www_form_component(token_data.to_json)
      cookies[:keycloak_token] = { value: encoded_token, path: "/", same_site: :lax }

      session[:user_id] = auth.user_id
      session[:user_info] = auth.info

      redirect_to "/authentication_success"
    else
      redirect_to root_path
    end
  end

  def success
    redirect_to root_path
  end

  def destroy
    cookes.delete(:keycloak_token)
    reset_session

    logout_url = "#{ENV['KEYCLOAK_SITE']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/logout?redirect_uri=#{CGI.escape(root_url)}"
    redirect_to logout_url, allow_other_host: true
  end
end
