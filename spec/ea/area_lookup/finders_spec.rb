require "spec_helper"

describe EA::AreaLookup do
  describe "Finders" do
    let(:coords) { EA::AreaLookup::Coordinates.new(easting: 654321, northing: 123456) }
    let(:api_url) { "http://www.geostore.com/OGC/OGCInterface" }

    it "has a version number" do
      expect(EA::AreaLookup::VERSION).not_to be nil
    end

    describe "Exception handling" do
      after(:each) { EA::AreaLookup.reset }

      it "raises an error if admin area api url is missing in config" do
        EA::AreaLookup.configure { |config| config.administrative_area_api_url = nil }
        expect { described_class.find_by_coordinates(coords) }
          .to raise_error(EA::AreaLookup::InvalidConfigError)
      end

      it "raises an error if connection cannot be made to the api" do
        EA::AreaLookup.config.administrative_area_api_url = "http://asdasdasdasd.example.com"
        expect { described_class.find_by_coordinates(coords) }
          .to raise_error(EA::AreaLookup::ApiConnectionError)
      end

      it "raise an error if the request is malformed (see cassette)" do
        EA::AreaLookup.config.administrative_area_api_url = api_url
        VCR.use_cassette("area_lookup_malformed_request") do
          expect {described_class.find_by_coordinates(coords)}
            .to raise_error(EA::AreaLookup::ApiInvalidRequestError)
        end
      end
    end
  end
end
