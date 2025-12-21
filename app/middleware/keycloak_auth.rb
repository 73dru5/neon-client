class KeycloakAuth
  def call(env)
    request = Rack::Request.new(env)
    cookie = request.cookies["keycloak_token"]

    if cookie
      begin
        decoded_cookie = URI.decode_www_form_component(cookie)
        token_data = JSON.parse(decoded_cookie)
        access_token = token_data["AccessToken"]

        decoded = JWT.decode(access_token, nil, false)[0]
        if decoded["exp"] < Time.now.to_i + 30  # Refresh if expiring soon
          refreshed = refresh_token(token_data["RefreshToken"])
          update_cookie(env, refreshed) if refreshed
          access_token = refreshed["AccessToken"]
        end

      # Validate as before
      # ...

      rescue => e
        # Handle errors
      end
    end
  end

  private

  def refresh_token(refresh_token)
    client = OAuth2::Client.new(
      ENV["KEYCLOAK_CLIENT_ID"],
      ENV["KEYCLOAK_CLIENT_SECRET"],
      site: "#{ENV['KEYCLOAK_SITE']}/realms/#{ENV['KEYCLOAK_REALM']}",
      token_url: "/protocol/openid-connect/token"
    )
    token = OAuth2::AccessToken.new(client, "", refresh_token: refresh_toekn)
    refreshed = token.refresh!.params # Returns hash with access_token, refresh_token
    { "AccessToken" => refreshed["access_token"], "RefreshToken" => refreshed["refresh_token"] }
  end

  def update_cookie(env, refreshed)
    response = Rack :Response.new
    encoded = URI.encode_www_form_component(refreshed.to_json)
    response.set_cookie("keycloak_token", { value: encoded, path: "/", same_site: :lax })
    env["HTTP_COOKIE"] = response.headers["Set-Cookie"]
  end
end
