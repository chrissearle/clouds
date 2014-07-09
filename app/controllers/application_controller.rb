class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :get_current_user

  helper_method :current_user

  def current_user
    @current_user if defined?(@current_user)
  end

  private

  def get_current_user
    if session.has_key? :user_id
      @current_user = User.get_user(session[:user_id])
    end
  end
end
