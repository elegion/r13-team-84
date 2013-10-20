class HomeController < ApplicationController

  def index
    @today_stats = DailyStatistics.stats_for_date(locale, Date.today)
  end

  def default_locale
    locale = http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    redirect_to "/#{locale}"
  end

end
