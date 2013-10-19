class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  before_filter :set_locale
  helper_method :current_user

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
    session[:user_id] = (@current_user = User.guest).id unless @current_user
    @current_user
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    self.default_url_options[:locale] = I18n.locale
  end

  def faye_client
    request.env['faye.client']
  end
end
