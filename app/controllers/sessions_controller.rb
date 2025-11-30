class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  def new
    @msg = "Hello, please log in"
  end

  def create
    @username = params[:username]
    @password = params[:password]
    # render :create
  end
end
