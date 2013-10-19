class FayeExtension
  def incoming(message, callback)
    # EventMachine::Timer.new(10) { p 'timer' }
    callback.call(message)
  end
end
