module Api::V2
  class KeysController < BaseController
    skip_before_action :authenticate_api_key!, only: :create

    # rescue_from ActiveRecord::RecordNotUnique do |exception|
    #   render json: { message: "choose another unique name for api key" }
    # end



    rescue_from ::ApiErrors::ApiKeyNameTaken do
      render json: { request_id: request.request_id, message: "choose another unique name for api key" }, status: :conflict
    end


    def create
      api_key = ApiKeys::CreateApiKey.call(
        name: params[:key_name],
        created_by: "user"
      )
      render json: api_key_response(api_key), status: :created
    end

    private

    def api_key_response(api_key)
      {
        id: api_key.id,
        key: api_key.key,
        name: api_key.name,
        created_at: api_key.created_at.utc.iso8601,
        created_by: api_key.created_by
      }
    end
  end
end
