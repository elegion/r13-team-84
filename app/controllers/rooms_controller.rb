class RoomsController < ApplicationController

  after_action :push_room_user_action, only: [ :join, :leave ]

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
    @room = current_user.leave
    redirect_to root_path
  end

  private

  def push_room_user_action
    channel = "/rooms/#{@room.id}/users/#{action_name}"
    faye_client.publish(channel, {
      user: current_user,
      user_link: user_path(current_user),
      class: view_context.color_class(current_user.id)
    })
  end

end
