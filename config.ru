# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

Faye::WebSocket.load_adapter('thin')
use Faye::RackAdapter, mount:'/faye', timeout: 25, extensions: [ FayeExtension.new ]

run Rails.application
