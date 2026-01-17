OmniAuth.config.allowed_request_methods = [ :post, :get ]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keycloak_openid,
    ENV["KEYCLOAK_CLIENT_ID"],
    ENV["KEYCLOAK_CLIENT_SECRET"],
    client_options: {
      site: "http://keycloak:8080",
      realm: ENV["KEYCLOAK_REALM"],
      base_url: "",
      redirect_uri: ENV["KEYCLAOK_REDIRECT_URI"],
      # discovery: false,
      # authorize_url: "#{ENV['KEYCLOAK_SITE']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/auth",
      token_url: "http://keycloak:8080/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/token",
      jwks_uri: "http://keycloak:8080/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/certs"
    },
    name: "keycloak"
end
