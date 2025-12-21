module Api::V2
  class BaseController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::Helpers

    before_action :authenticate_api_key!
    before_action :ensure_json_request

    rescue_from ActiveRecord::RecordNotFound do
      render json: { message: "record not found" }, status: :not_found
    end

    rescue_from ActiveRecord::RecordNotUnique do
      render json: { message: "record not unique" }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordInvalid do
      render json: { message: "record invalid", request_id: request.request_id }, status: :conflict
    end

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

    def ensure_json_request
      request.format = :json
    end
  end
end
