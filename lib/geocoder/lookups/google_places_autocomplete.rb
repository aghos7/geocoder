require "geocoder/lookups/google"
require "geocoder/results/google_places_autocomplete"

module Geocoder
  module Lookup
    class GooglePlacesAutocomplete < Google
      def name
        "Google Places Auto Complete"
      end

      def required_api_key_parts
        ["key"]
      end

      def supported_protocols
        [:https]
      end

      def query_url(query)
        "#{protocol}://maps.googleapis.com/maps/api/place/autocomplete/json?#{url_query_string(query)}"
      end

      private

      def results(query)
        return [] unless doc = fetch_data(query)

        case doc["status"]
        when "OK"
          return doc["predictions"]
        when "OVER_QUERY_LIMIT"
          raise_error(Geocoder::OverQueryLimitError) || Geocoder.log(:warn, "Google Places Autocomplete API error: over query limit.")
        when "REQUEST_DENIED"
          raise_error(Geocoder::RequestDenied) || Geocoder.log(:warn, "Google Places Autocomplete API error: request denied.")
        when "INVALID_REQUEST"
          raise_error(Geocoder::InvalidRequest) || Geocoder.log(:warn, "Google Places Autocomplete API error: invalid request.")
        end

        []
      end

      def query_url_google_params(query)
        {
          input: query.text
        }.merge(super)
      end
    end
  end
end
