require "geocoder/results/google"

module Geocoder
  module Result
    class GooglePlacesAutocomplete < Base
      def predictions
        return @data
      end

      def place_id
        @data['place_id']
      end
    end
  end
end
