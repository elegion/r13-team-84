class FayeExtension

  def incoming(message, callback)
    p message
    callback.call(message)
    case message["channel"]
    when "/heartbeat"
      heartbeat(message["data"])
    end
  end

  private

  def heartbeat(data)
    User.find_by_id(data["user_id"]).try(:heartbeat)
  end

end
