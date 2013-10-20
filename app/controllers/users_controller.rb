class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @user_stats = {
        ru: DailyStatistics.stats_for_user('ru', @user),
        en: DailyStatistics.stats_for_user('en', @user),
    }
    render layout: !request.xhr?
  end

end
