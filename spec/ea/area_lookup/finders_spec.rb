require "spec_helper"

describe EA::AreaLookup do
  describe "Finders" do
    let(:coords) { EA::AreaLookup::Coordinates.new(easting: 654321, northing: 123456) }
    let(:api_url) { "http://www.geostore.com/OGC/OGCInterface" }

    it "has a version number" do
      expect(EA::AreaLookup::VERSION).not_to be nil
    end

    context "happy path" do
      before { EA::AreaLookup.config.administrative_area_api_url = api_url }
      context "area found" do
        let(:coords) { EA::AreaLookup::Coordinates.new(easting: 358205.03, northing: 172708.07) }
        it "returns hash with area info" do
          VCR.use_cassette("area_found") do
            hash = described_class.find_by_coordinates(coords)
            expect(hash).to eq({area_id: "28.000000000000000",
                                code: "WESSEX",
                                area_name: "Wessex",
                                short_name: "Wessex",
                                long_name: "Wessex"})
          end
        end
      end

      context "area not found" do
        let(:coords) { EA::AreaLookup::Coordinates.new(easting: 1, northing: 2) }
        it "returns empty hash" do
          VCR.use_cassette("area_not_found") do
            hash = described_class.find_by_coordinates(coords)
            expect(hash).to eq({area_id: "",
                                code: "",
                                area_name: "",
                                short_name: "",
                                long_name: ""})
          end
        end
      end
    end

    context "sad path" do
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
          VCR.use_cassette("malformed_request") do
            expect {described_class.find_by_coordinates(coords)}
              .to raise_error(EA::AreaLookup::ApiInvalidRequestError)
          end
        end
      end
    end
  end
end
