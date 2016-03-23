require "nokogiri"
require "open-uri"

module EA
  module AreaLookup
    module Finders
      def find_by_coordinates(coords)
        validate_config!
        return nil unless coords && coords.valid?
        xml = fetch_admin_area_from_api(coords)
        parse_xml(xml)
      end

      private

      def api_url
        EA::AreaLookup.config.administrative_area_api_url
      end

      def validate_config!
        if api_url.nil?
          fail EA::AreaLookup::InvalidConfigError.new("Missing administrative_area_api_url")
        end
      end

      def fetch_admin_area_from_api(coords)
        params = {
          SERVICE: "WFS",
          INTERFACE: "ENVIRONMENTWFS",
          VERSION: "1.1.0",
          REQUEST: "GetFeature",
          MSVER: 6,
          SRS: "EPSG:27700",
          TYPENAME: "ea-wfs-area_public_face_inspire",
          propertyName: "long_name,short_name,code,area_id,area_name",
          Filter: "(#{filter_xml(coords)})"
        }
        full_url = %[#{api_url}?#{params.map { |k, v| "#{k}=#{v}"}.join('&')}]

        open full_url, proxy: ENV["http_proxy"]
      rescue => e
        raise EA::AreaLookup::ApiConnectionError,
              "Failed with error #{e.inspect} trying to GET #{full_url}"
      end

      def filter_xml(coords)
        "<Filter><Intersects>" \
        "<PropertyName>Geometry</PropertyName>" \
        "<gml:Point><gml:coordinates>#{coords.easting},#{coords.northing}</gml:coordinates></gml:Point>" \
        "</Intersects></Filter>"
      end

      def parse_xml(response)
        xml = Nokogiri::XML response
        validate_xml(xml)

        result = %i[area_id code area_name short_name long_name].each_with_object({}) do |path, hash|
          hash[path] = xml.xpath("//gml:featureMember/ms:ea-wfs-area_public_face_inspire/ms:#{path}").text
        end
        result.tap {|h| Rails.logger.debug(h) }
      end

      def validate_xml(xml)
        if xml.namespaces["xmlns:ows"] && xml.xpath("//ows:Exception").count > 0
          fail EA::AreaLookup::ApiInvalidRequestError,
               "API returned an exception: #{xml.text && xml.text.strip}"
        end
      end
    end
  end
end
