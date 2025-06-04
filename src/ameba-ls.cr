require "larimar/api/provider_server"
require "ameba"
require "option_parser"

require "./ameba-ls/provider"

OptionParser.parse do |parser|
  parser.banner = "language server for the ameba linter for crystal lang"

  parser.on "-v", "--version", "Show version" do
    puts "version: " + {{ env("APP_VERSION") || "dev" }}
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.invalid_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is not a valid option."
    STDERR.puts parser
    exit 1
  end
end

server = Larimar::Server.new(STDIN, STDOUT)

backend = Larimar::LogBackend.new(server, formatter: Larimar::LogFormatter)
::Log.setup_from_env(backend: backend)

controller = Larimar::ProviderController.new
controller.register_provider(AmebaProvider.new)

server.start(controller)
