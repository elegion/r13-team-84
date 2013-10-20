class HomeController < ApplicationController

  def index
    @fastest_answers = DailyStatistics.where(locale: locale, stats_date: Date.today).order('fastest_answer DESC')
    @answers_in_a_row = DailyStatistics.where(locale: locale, stats_date: Date.today).order('answers_in_a_row DESC')
    @correct_answers = DailyStatistics.where(locale: locale, stats_date: Date.today).order('correct_answers DESC')
  end

  def default_locale
    locale = http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    redirect_to "/#{locale}"
  end

end
