require "larimar"
require "ameba"

require "./ameba-ls/provider"

server = Larimar::Server.new(STDIN, STDOUT)

backend = Larimar::LogBackend.new(server, formatter: Larimar::LogFormatter)
::Log.setup_from_env(backend: backend)

controller = Larimar::ProviderController.new
controller.register_provider(AmebaProvider.new)

server.start(controller)
