class SessionsController < ApplicationController

  def callback
    user = User.from_omniauth(auth_hash)
    session[:user_id] = user.id
    redirect_to(root_url)
  end

  def failure
    redirect_to(root_url)
  end

  def signout
    return redirect_to(root_url) unless current_user
  end

  def destroy
    session.clear
    redirect_to(root_url)
  end

  private
  def auth_hash
    env["omniauth.auth"]
  end

end
