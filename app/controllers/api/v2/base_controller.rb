module Api::V2
  class BaseController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::Helpers
    include JsonExceptionHandler

    before_action :authenticate_api_key!

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { message: "record not found" }
    end

    rescue_from ActiveRecord::RecordInvalid, with: :uprocessable_entity

    private

    def authenticate_api_key!
      auth = request.headers["Authorization"]
      unless auth&.start_with?("Bearer")
        render json: { error: "missing or invalid authorization header" }, status: :unauthorized
        return
      end

      token = auth.split(" ", 2).last

      @api_key = ApiKey.find_by!(token: token)

      unless @api_key
        render json: { error: "invalid api key" }, status: :unauthorized
      end

      @api_key.update_column(:last_used_at, Time.current)

      @current_user = @api_key.user
    end

    def valid_api_key?(token)
      ActiveSupport::SecurityUtils.secure_compare(token, ENV["API_KEY"])
    end

    def set_default_format
      request.format = :json if request.headers["HTTP_ACCEPT"].nil? && params[:format].nil?
    end

    def not_found
      render json: { error: exception.message }, status: :not_found
    end

    def uprocessable_entity(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :uprocessable_entity
    end

    def forbidden
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
