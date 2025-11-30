module Api::V2
  class UsersController < ::ApplicationController
    def me
      render json: current_user, status: :ok
    end

    def organizations
      organizations = current_user.organizations
      render json: organizations, status: :ok
    end
  end
end
