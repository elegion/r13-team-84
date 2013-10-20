class FayeExtension

  def incoming(message, callback)
    p message
    callback.call(message)
    # case message["channel"]
    # when "/meta/subscribe"
    #   subscribe(message['subscription'])
    # end
  end

private

  # def subscribe(subscription)
  #   if %r{/rooms/(?<room_id>\d+)} =~ subscription
  #     room_timers[room_id]
  #   end
  # end

end
