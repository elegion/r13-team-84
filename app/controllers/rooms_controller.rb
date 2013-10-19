class RoomsController < ApplicationController

  def show
    @room = Room.find(params[:id])
    redirect_to root_path unless @room.users.include? current_user
  end

  def join
    room = Room.first_not_full
    room.join current_user
    redirect_to room
  end

end
