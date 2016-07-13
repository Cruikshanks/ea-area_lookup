require "spec_helper"

describe EA::AreaLookup::Configuration do
  it { is_expected.to respond_to(:area_api_url) }

  describe "#configure" do
    it "can set and get configuration options" do
      EA::AreaLookup.configure do |c|
        c.area_api_url = "a"
      end
    end
  end

  describe "#reset" do
    it "clears down previously set configuration" do
      EA::AreaLookup.configure { |c| c.area_api_url = "a" }
      expect(EA::AreaLookup.config.area_api_url).to eq("a")
      EA::AreaLookup.reset
      expect(EA::AreaLookup.config.area_api_url).to_not eq("a")
    end
  end
end
