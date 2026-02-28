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
    # debugger
    auth = request.env["omniauth.auth"]

    # Set the keycloak_token cookie
    if auth
      token_data = {
        AccessToken: auth.credentials.token,
        RefreshToken: auth.credentials.refresh_token
      }
      encoded_token = URI.encode_www_form_component(token_data.to_json)
      cookies[:keycloak_token] = { value: encoded_token, path: "/", same_site: :lax }

      # Initialize the session oject if you want
      # session[:user_id] = auth.user_id
      # session[:user_info] = auth.info

      # To expose the content of the auth hash
      # auth_json = auth.to_json
      # puts auth_json

      email = auth.info.email

      @user = User.find_or_initialize_by(email: email)
      debugger
      if @user.new_record?
        info = auth.info
        auth_account = {
          uid: auth.uid,
          provider: auth.provider,
          name: info.name,
          image: "",
          login: auth.name,
          email: info.email
        }
        @user.add_auth_account(auth_account)
      else
        redirect_to root_path

      end


      render json: auth.to_h
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
