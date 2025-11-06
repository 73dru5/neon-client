class PagesController < ApplicationController
  def home
    @message = "Hello from Rails!"
    @version = ActiveRecord::Base.connection.execute("SELECT version()").first["version"]
    @id = params[:id]
  end

  def login
    @msg = "Hello! Please log in."
    @username = params[:username]
    Rails.logger.info("The username: #{@username}")
  end
end
