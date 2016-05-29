require "spec_helper"
module EA
  module AreaLookup
    module TestHelper
      describe MockData do
        let(:mock_data) { described_class.new(:area_lookup) }
        let(:api_url)   { "http://www.geostore.com/OGC/OGCInterface" }

        describe "#data_for" do
          context "with :find_by_coordinates" do
            let(:data) { mock_data.data_for :find_by_coordinates }

            it "mock data should match the keys in the real http response - "\
               "this catches the scenario where the underlying API has changed but "\
               "the mock data has not been updated to reflect this" do
              EA::AreaLookup.config.administrative_area_api_url = api_url
              coords = EA::AreaLookup::Coordinates.new(easting: 358_205.03, northing: 172_708.07)
              response = VCR.use_cassette("area_found") do
                EA::AreaLookup.find_by_coordinates(coords)
              end
              data = mock_data.data_for(:find_by_coordinates)

              expect(data.keys.sort).to eq(response.keys.sort)
            end
          end
        end
      end
    end
  end
end
