class RoomsController < ApplicationController

  def show
    @room = Room.find(params[:id])
  end

  def join
    room = Room.first_not_full
    room.join current_user
    redirect_to room
  end

end
