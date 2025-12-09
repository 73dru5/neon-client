module Api::V2
  class KeyController < BaseController
    skip_before_action :authenticate_api_key!, only: :create
    def create
      # Auto-create table if it doesn't exist (great for fresh dev environments)
      unless ActiveRecord::Base.connection.table_exists?("api_keys")
        ActiveRecord::Migrator.migrate("db/migrate")
      end

      api_key = ApiKey.create!(
        name: key_params[:key_name].presence,
        created_by: "user"
      )

      render json: api_key_response(api_key), status: :created
    end

    private

    def key_params
      params.permit(:key_name)
    end

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
