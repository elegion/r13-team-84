class RoomsDeamon::RoomsManager

  attr_accessor :room_hash, :faye_client

  def initialize(faye_client)
    @room_hash = Hash.new
    @faye_client = faye_client
  end

  def push_room(room)
    room_watcher = RoomWatcher.new(room, faye_client)
    room_hash[room.id] = room_watcher

    faye_client.subscribe(room_watcher.questions_channel) do |message|
      room_watcher.update_room_question
    end

    # TODO: Watch new rooms
  end

end
