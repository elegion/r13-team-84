class HomeController < ApplicationController

  def index
  end

  def default_locale
    locale = http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    redirect_to "/#{locale}"
  end

end
