module EA
  module AreaLookup
    class Coordinates
      attr_accessor :easting, :northing
      alias x easting
      alias y northing

      def initialize(easting:, northing:)
        @easting = easting
        @northing = northing
      end

      def valid?
        easting && northing
      end
    end
  end
end
