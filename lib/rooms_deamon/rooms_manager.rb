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
        logger.debug [ :room_question, room_watcher.questions_channel, message ]
        room_watcher.update_room_question
      end

    end
  rescue => error
    logger.error error
  end

  def push_room_id(room_id)
    room = Room.find(room_id)
    push_room(room)
  end

  def search_new_rooms
    faye_client.subscribe('/rooms/touch') do |message|
      logger.debug([ :rooms_touch, message ])
      self.push_room_id(message['room_id'])
    end
  end

  def push_rooms
    Room.find_each { |room| push_room(room) }
  end

protected

  def logger
    Rails.logger
  end

end
