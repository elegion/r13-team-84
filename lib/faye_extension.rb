class FayeExtension

  attr_accessor :room_timers

  def initialize
    @room_timers = Hash.new
  end

  def incoming(message, callback)
    callback.call(message)
    case message["channel"]
    when "/meta/subscribe"
      subscribe(message['subscription'])
    end
  end

private

  def subscribe(subscription)
  #   if %r{/rooms/(?<room_id>\d+)} =~ subscription
  #     room_timers[room_id]
  #   end
    # EventMachine::Timer.new(10) { p 'timer' }
  end

end
