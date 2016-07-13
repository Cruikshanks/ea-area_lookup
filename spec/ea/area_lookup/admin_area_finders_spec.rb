require "spec_helper"

describe EA::AreaLookup do
  describe "Finders" do
    let(:coords) { EA::AreaLookup::Coordinates.new(easting: 654_321, northing: 123_456) }
    let(:api_url) { "http://environment.data.gov.uk/ds/wfs" }

    it "has a version number" do
      expect(EA::AreaLookup::VERSION).not_to be nil
    end

    context "admin area happy path" do
      before { EA::AreaLookup.config.area_api_url = api_url }
      context "area found" do
        let(:coords) { EA::AreaLookup::Coordinates.new(easting: 358_205.03, northing: 172_708.07) }
        it "returns hash with area info" do
          VCR.use_cassette("admin_area_found") do
            hash = described_class.find_admin_area_by_coordinates(coords)
            expect(hash).to eq(area_id: "28.000000000000000",
                               code: "WESSEX",
                               area_name: "Wessex",
                               short_name: "Wessex",
                               long_name: "Wessex")
          end
        end
      end

      context "admin area not found" do
        let(:coords) { EA::AreaLookup::Coordinates.new(easting: 1, northing: 2) }
        it "returns empty hash" do
          VCR.use_cassette("admin_area_not_found") do
            hash = described_class.find_admin_area_by_coordinates(coords)
            expect(hash).to eq(area_id: "",
                               code: "",
                               area_name: "",
                               short_name: "",
                               long_name: "")
          end
        end
      end
    end

    context "sad path" do
      describe "Exception handling" do
        after(:each) { EA::AreaLookup.reset }

        it "raises an error if admin area api url is missing in config" do
          EA::AreaLookup.configure { |config| config.area_api_url = nil }
          expect { described_class.find_admin_area_by_coordinates(coords) }
            .to raise_error(EA::AreaLookup::InvalidConfigError)
        end

        it "raises an error if connection cannot be made to the api" do
          EA::AreaLookup.config.area_api_url = "http://asdasdasdasd.example.com"
          expect { described_class.find_admin_area_by_coordinates(coords) }
            .to raise_error(EA::AreaLookup::ApiConnectionError)
        end

        it "raise an error if the request is malformed (see cassette)" do
          EA::AreaLookup.config.area_api_url = api_url
          VCR.use_cassette("admin_area_malformed_request") do
            expect { described_class.find_admin_area_by_coordinates(coords) }
              .to raise_error(EA::AreaLookup::ApiInvalidRequestError)
          end
        end
      end
    end
  end
end
