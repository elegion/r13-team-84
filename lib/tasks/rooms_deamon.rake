require 'eventmachine'
require 'faye'
require 'daemons'

namespace :rooms_deamon do

  desc "Run foreground"
  task :run => :environment do
    RoomsDeamon.new(false).start
  end

  desc "Run background"
  task :start => :environment do
    RoomsDeamon.new(true).start
  end

  desc "Stop background"
  task :stop => :environment do
   'kill -TERM `cat tmp/pids/rooms_daemon.pid`'
    RoomsDeamon.new(true).stop(ENV['SIGNAL'])
  end

end # namespace :rooms_deamon
