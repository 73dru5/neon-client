# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # 1. Configuration for Local Development
  allow do
    # The URL of your React/SPA dev server
    origins "http://localhost:5173"

    resource "*", # This applies to all API routes
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end

  # 2. Configuration for Production (Always be specific for security)
  # allow do
  #   origins 'https://your-frontend-domain.com'
  #   resource '*',
  #     headers: :any,
  #     methods: [:get, :post, :put, :patch, :delete, :options, :head],
  #     credentials: true # Use this if your requests include cookies/auth headers
  # end
end
