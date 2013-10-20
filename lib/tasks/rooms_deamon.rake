require 'eventmachine'
require 'faye'
require 'daemons'

namespace :rooms_deamon do
  task :run => :environment do
    Rails.logger = Logger.new(Rails.root.join('log/rooms_deamon.log'))
    EventMachine.run do
      # Control + C for stop
      Signal.trap("INT")  { EventMachine.stop }
      Signal.trap("TERM") { EventMachine.stop }

      faye_client = Faye::Client.new(Settings.rooms_deamon.faye_url)

      rooms_deamon = RoomsDeamon::RoomsManager.new(faye_client)
      Room.find_each { |room| rooms_deamon.push_room(room) }
    end #EventMachine.run
  end # task :run
end # namespace :rooms_deamon
