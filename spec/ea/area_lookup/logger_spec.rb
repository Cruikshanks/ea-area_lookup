require "spec_helper"

describe EA::AreaLookup do
  subject { EA::AreaLookup }

  describe "#logger" do
    it { is_expected.to respond_to(:logger) }

    it "creates a default logger with log level DEBUG if no logger supplied" do
      expect(described_class.logger).to_not be_nil
      expect(described_class.logger).to be_a(Logger)
      expect(described_class.logger.level).to eq(Logger::DEBUG)
    end

    class MyLogger < Logger; end

    it "lets you being your own logger" do
      my_logger = MyLogger.new($stdout).tap do |log|
        log.progname = "my_logger"
        log.level = Logger::WARN
      end
      described_class.logger = my_logger
      expect(described_class.logger).to be_a(MyLogger)
      expect(described_class.logger.level).to eq(Logger::WARN)
    end
  end
end
