class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  before_filter :set_locale
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    self.default_url_options[:locale] = I18n.locale
  end
end
