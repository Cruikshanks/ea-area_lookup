require_relative "mock_data"
module EA
  module AreaLookup
    module TestHelper
      # Uses data from area_lookup.yml to mock calls to EA::AreaLookup methods
      module RspecMocks

        def mock_ea_area_lookup_find_by_coordinates
          allow(EA::AreaLookup)
            .to receive(:find_by_coordinates)
            .and_return(mock_data.data_for(:find_by_coordinates))
        end

        def mock_no_results_ea_area_lookup_find_by_coordinates
          allow(EA::AddressLookup)
            .to receive(:find_by_coordinates)
            .and_return(mock_data.data_for(:find_by_coordinates_not_found))
        end

        def mock_failure_of_ea_area_lookup_find_by_coordinates
          allow(EA::AddressLookup)
            .to receive(:find_by_coordinates)
            .and_raise(EA::AreaLookup::ApiConnectionError, "Whoops")
        end

        private

        def mock_data
          @mock_data ||= MockData.new :address_lookup
        end

      end
    end
  end
end
