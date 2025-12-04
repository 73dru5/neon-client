module Api::V2
  class UsersController < BaseController
    def me
      user = User.find_by!(name: "phaedrus")
      render json: user, status: :ok
    end

    def organizations
      organizations = current_user.organizations
      render json: organizations, status: :ok
    end
  end
end
