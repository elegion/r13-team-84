class HomeController < ApplicationController

  def index
  end

  def default_locale
    available = %w{en ru}
    locale = http_accept_language.compatible_language_from(available) || I18n.default_locale
    redirect_to "/#{locale}"
  end
end
