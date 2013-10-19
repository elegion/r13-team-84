class RoomsController < ApplicationController

  def show
    @room = Room.find(params[:id])
    redirect_to root_path unless @room.users.include? current_user
  end

  def join
    @room = Room.first_not_full
    current_user.join @room
    redirect_to @room
  end

  def leave
    current_user.leave
    redirect_to root_path
  end

end
