require "spec_helper"

describe EA::AreaLookup::Configuration do

  it {is_expected.to respond_to(:yay) }

  describe "#configure" do
    it "can set and get configuration options" do
      EA::AreaLookup.configure do |c|
        c.yay = "a"
      end
    end
  end

  describe "#reset" do
    it "clears down previously set configuration" do
      EA::AreaLookup.configure { |c| c.yay = "a" }
      EA::AreaLookup.reset
      expect(EA::AreaLookup.config.yay).to be_nil
    end
  end
end
