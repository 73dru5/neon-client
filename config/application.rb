require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NeonClient
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_paths << Rails.root.join("app/errors")
    config.eager_load_paths << Rails.root.join("app/errors")
  end
end

module JsonExceptionHandler
  def self.included(base)
    base.rescue_from StandardError, with: :render_error_response if Rails.env.development? || Rails.env.test?
  end

  private

  def render_error_response(exception)
    status = case exception
    when ActionController::ParameterMissing then 400
    when ActiveRecord::RecordNotFound      then 404
    when ActiveRecord::RecordInvalid       then 422
    else 500
    end

    render json: {
      error: {
        message: exception.message,
        backtrace: Rails.backtrace_cleaner.clean(exception.backtrace)
      }
    }, status: status
  end
end
