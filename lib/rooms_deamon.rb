# Use with module only in loop of eventmachine
class RoomsDeamon

  attr_reader :background

  def initialize(background)
    @background = background

    Rails.logger = Logger.new(logger_output)
  end

  def start
    start_daemon_if_background
    logger.debug("EM.run"); 
    EM.run do

      EM.error_handler { |error| logger.error(error) }

      # Control + C for stop
      Signal.trap("INT")  { EM.stop }
      Signal.trap("TERM") { EM.stop }

      Room.find_each { |room| rooms_deamon.push_room(room) }
      @user_manager ||= RoomsDeamon::UserManager.new(faye_client)

    end #EventMachine.run
    logger.debug('EM.stop'); 
    end_daemon_if_background
  end

  def stop(signal)
    if File.exists?(pid_file_path)
      pid = File.read(pid_file_path).to_i
      Process.kill(signal || 'TERM', pid)
    end
  end

protected

  def logger_output
    background ? Rails.root.join('log/rooms_daemon.log') : STDOUT
  end

  def pid_file_path
    Rails.root.join('tmp/pids/rooms_daemon.pid').to_s
  end

  def start_daemon_if_background
    if background 
      Process.daemon
      logger.debug("daemon")
      File.write(pid_file_path, Process.pid.to_s)
      logger.debug("pid: #{Process.pid}")
    end
  end

  def end_daemon_if_background
    if background
      File.unlink(pid_file_path)
    end
  end

  def logger
    @logger ||= Rails.logger
  end

  def faye_client
    @faye_client ||= Faye::Client.new(Settings.rooms_deamon.faye_url)
  end

  def rooms_deamon
    @rooms_deamon ||= RoomsDeamon::RoomsManager.new(faye_client)
  end

end
