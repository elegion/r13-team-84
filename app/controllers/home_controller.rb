class HomeController < ApplicationController

  def index
    @today_stats = DailyStatistics.stats_for_date(locale, Date.today)
    @week_stats = DailyStatistics.stats_for_range(locale, Date.today - 6.days, Date.today)
    @month_stats = DailyStatistics.stats_for_range(locale, Date.today - 30.days, Date.today)
  end

  def default_locale
    locale = http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    redirect_to "/#{locale}"
  end

end
