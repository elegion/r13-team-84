class RoomsDeamon::UserManager

  KICK_USERS_INTERVAL = 30.seconds

  attr_accessor :faye_client

  def initialize(faye_client)
    @faye_client = faye_client
    monitor_users
  end

  def monitor_users
    EventMachine::PeriodicTimer.new(KICK_USERS_INTERVAL, method(:kick_users))
  end

  def kick_users
    User.where.not(room_id: nil).where("updated_at < ?", Time.now - KICK_USERS_INTERVAL).find_each do |u|
      @faye_client.publish("/rooms/#{u.room.id}/users/leave", user: u)
      u.leave
    end
  end

  protected

  def logger
    Rails.logger
  end

end
