class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    self.default_url_options[:locale] = I18n.locale
  end
  before_filter :set_locale
end
