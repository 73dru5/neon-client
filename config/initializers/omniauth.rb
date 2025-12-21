Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keycloak_openid,
    ENV["KEYCLOAK_CLIENT_ID"],
    ENV["KEYCLOAK_CLIENT_SECRET"],
    client_options: {
      site: "#{ENV['KEYCLOAK_SITE']}/realms/#{ENV['KEYCLOAK_REALM']}",
      realm: ENV["KEYCLOAK_REALM"],
      base_url: "/protocol/openid-connect",
      redirect_uri: ENV["KEYCLAOK_REDIRECT_URI"]
    },
    name: "keycloak"
end
