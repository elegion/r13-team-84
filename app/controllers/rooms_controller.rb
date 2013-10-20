class RoomsController < ApplicationController

  after_action :push_room_user_action, only: [ :join, :leave ]
  after_action :touch_room, only: [ :show ]

  def show
    @room = Room.find(params[:id])
    if !@room.users.include?(current_user)
      _push_room_user_action(@room, 'join')
      current_user.join(@room)
    end
  end

  def join
    @room = Room.first_not_full
    _push_room_user_action(current_user.room, 'leave') if current_user.room
    current_user.join @room
    redirect_to @room
  end

  def leave
    @room = current_user.leave
    redirect_to home_path
  end

  private

  def push_room_user_action
    _push_room_user_action(@room, action_name)
  end

  def _push_room_user_action(room, action)
    channel = "/rooms/#{room.id}/users/#{action}"
    faye_client.publish(channel, {
      user: current_user,
      html: render_to_string('rooms/_user', locals: {user: current_user}, layout: false)
    })
  end

  def touch_room
    faye_client.publish("/rooms/touch", { room_id: @room.id })
  end

end
