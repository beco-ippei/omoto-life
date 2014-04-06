class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_filter :authenticate_user!
  after_filter :store_location

  alias_method :devise_current_user, :current_user

  # store last url - redirect to whatever the user last visited.
  def store_location
    ex_pathes = %w[sign_in sign_up password sign_out].map {|p| "/users/#{p}" }
    if (!ex_pathes.include?(request.fullpath) && !request.xhr?)
      # don't store sign_in/out or ajax calls for "after_sign_in_path_for"
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
end
