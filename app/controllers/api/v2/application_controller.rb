module Api::V2
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::Helpers
    # include DeviceTokenAuth::Concerns::SetUserByToken
    # include Pundit::Authorization

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { message: 'record not found' }
    end
    rescue_from ActiveRecord::RecordInvalid, with: :uprocessable_entity
    # rescue_from Pundit::NotAuthorizedError, with: :forbidden

    # before_action :authenticate_user!
    # before_action :set_default_format

    private

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
