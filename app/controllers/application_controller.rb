class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_filter :authenticate_user!
  after_filter :store_location

  # store last url - redirect to whatever the user last visited.
  def store_location
    session[:previous_url] = request.fullpath
  end

  # configure at config/initializers/sorcery.rb
  def redirect_for_login
    store_location
    redirect_to login_path
  end
end
