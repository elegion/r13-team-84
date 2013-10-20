require 'eventmachine'
require 'faye'

namespace :rooms_deamon do
  desc %w{ Run 'rake rooms_deamon:run FAYE_URL="http://localhost:3000/faye"' } 
  task :run => :environment do
    EventMachine.run do
      # Control + C for stop
      Signal.trap("INT")  { EventMachine.stop }
      Signal.trap("TERM") { EventMachine.stop }

      faye_client = Faye::Client.new(ENV['FAYE_URL'])

      rooms_deamon = RoomsDeamon::RoomsManager.new(faye_client)
      Room.find_each { |room| rooms_deamon.push_room(room) }
    end #EventMachine.run
  end # task :run
end # namespace :rooms_deamon
