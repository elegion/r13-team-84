class RoomsController < ApplicationController

  def show
    @root = Room.find(params[:id])
  end

  def join
    if (last_room = Room.last).try(:full?)
      new_room = Room.create(name: "Room #{Room.count + 1}")
      redirect_to new_room
    else
      redirect_to last_room
    end
  end

end
