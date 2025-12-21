class SessionsController < ApplicationController
  def new
    redirect_to "/auth/keycloak"
  end

  def create
    auth = request.env["omniauth.auth"]
    if auth
      token_data = {
        AccessToken: auth.credentials.token,
        RefreshToken: auth.credentials.token
      }
      encoded_token = URI.encode_www_form_component(token_data.to_json)
      cookies[:keycloak_token] = { value: encoded_token, path: "/", same_site: :lax }

      session[:user_id] = auth.user_id
      session[:user_info] = auth.info

      redirect_to root_path, notice: "Logged in!"
    else
      redirect_to root_path, alert: "Authentication failed."
    end
  end

  def destroy
    cookes.delete(:keycloak_token)
    reset_session

    logout_url = "#{ENV['KEYCLOAK_SITE']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/logout?redirect_uri=#{CGI.escape(root_url)}"
    redirect_to logout_url, allow_other_host: true
  end
end
