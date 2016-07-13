require "nokogiri"
require "open-uri"

module EA
  module AreaLookup
    module Finders

      def find_admin_area_by_coordinates(coords)
        validate_config!
        return nil unless coords && coords.valid?
        typename = "ea-wfs-area_public_face_inspire"
        xml = fetch_area_from_api(coords, typename)
        parse_xml(xml, typename)
      end

      def find_water_management_area_by_coordinates(coords)
        validate_config!
        return nil unless coords && coords.valid?
        typename = "ea-wfs-area_water_management_inspire"
        xml = fetch_area_from_api(coords, typename)
        parse_xml(xml, typename)
      end

      private

      DEFAULT_API_PARAMS = {
        SERVICE: "WFS",
        INTERFACE: "ENVIRONMENTWFS",
        VERSION: "1.1.0",
        REQUEST: "GetFeature",
        MSVER: 6,
        SRS: "EPSG:27700",

        propertyName: "long_name,short_name,code,area_id,area_name",
        Filter: ""
      }.freeze

      def api_url
        EA::AreaLookup.config.area_api_url
      end

      def validate_config!
        return if api_url
        raise EA::AreaLookup::InvalidConfigError, "Missing area_api_url"
      end

      def fetch_area_from_api(coords, typename)
        params = DEFAULT_API_PARAMS
                 .merge(Filter: "(#{filter_xml(coords)})")
                 .merge(TYPENAME: typename)

        full_url = %(#{api_url}?#{params.map { |k, v| "#{k}=#{v}" }.join('&')})
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

      def parse_xml(response, typename)
        xml = Nokogiri::XML response
        validate_xml(xml)

        result = %i(area_id code area_name short_name long_name).each_with_object({}) do |path, hash|
          hash[path] = xml.xpath("//gml:featureMember/ms:#{typename}/ms:#{path}").text
        end
        result.tap { |h| EA::AreaLookup.logger.debug(h) }
      end

      def validate_xml(xml)
        if xml.namespaces["xmlns:ows"] && xml.xpath("//ows:Exception").count > 0
          raise EA::AreaLookup::ApiInvalidRequestError,
                "API returned an exception: #{xml.text && xml.text.strip}"
        end
      end
    end
  end
end
