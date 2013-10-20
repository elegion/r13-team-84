class SessionsController < ApplicationController

  def callback
    user = current_user.authentificate(auth_hash)
    session[:user_id] = user.id
    redirect_to(request.env['omniauth.origin'] || home_url)
  end

  def failure
    redirect_to(request.env['omniauth.origin'] || home_url)
  end

  def signout
    return redirect_to(home_url) unless current_user
  end

  def destroy
    session.clear
    redirect_to(request.env['omniauth.origin'] || home_url)
  end

  private
  def auth_hash
    env["omniauth.auth"]
  end

end
