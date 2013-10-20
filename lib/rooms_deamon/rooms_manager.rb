class RoomsDeamon::RoomsManager

  attr_accessor :room_hash, :faye_client

  def initialize(faye_client)
    @room_hash = Hash.new
    @faye_client = faye_client
  end

  def push_room(room)
    logger.debug [:push_room, room]

    unless room_hash.key?(room.id) 
      room_watcher = RoomsDeamon::RoomWatcher.new(room, faye_client)
      room_hash[room.id] = room_watcher

      faye_client.subscribe(room_watcher.questions_channel) do |message|
        logger.debug [ :message, room_watcher.questions_channel, message ]
        room_watcher.update_room_question
      end

      # TODO: Watch new rooms
    end
  rescue => error
    logger.error error
  end

protected

  def logger
    Rails.logger
  end

end
