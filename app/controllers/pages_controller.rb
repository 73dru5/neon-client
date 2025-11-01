class PagesController < ApplicationController
  def home
    @message = "Hello from Rails!"
    @version = ActiveRecord::Base.connection.execute("SELECT version()").first["version"]
  end
end
