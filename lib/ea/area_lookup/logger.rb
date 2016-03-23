# A consumer can hook into logging like so:
#   EA::AreaLookup.logger = Rails.logger
# or to silence logging unless there are errors for example:
#  EA::AreaLookup.logger.level = Logger::ERROR
#
require "logger"

module EA
  module AreaLookup
    class << self
      attr_writer :logger

      def logger
        @logger ||= Logger.new($stdout).tap do |log|
          log.progname = self.name
          log.level = Logger::DEBUG
        end
      end
    end
  end
end
