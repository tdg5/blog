module JekyllHueman
  module Sitemap
    class Entry
      attr_accessor :change_frequency, :last_modified_date, :location, :priority

      def initialize(location, last_modified_date, change_frequency = nil, priority = nil)
        @change_frequency = change_frequency
        @last_modified_date = last_modified_date
        @location = location
        @priority = priority
      end

      def to_liquid
        entry = {
          "location" => location,
          "last_modified_date" => last_modified_date.iso8601,
        }
        entry["change_frequency"] = change_frequency if change_frequency
        entry["priority"] = priority if priority
        entry
      end
    end
  end
end
