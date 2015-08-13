module JekyllHueman
  module Sitemap
    class Entry
      attr_accessor :change_frequency, :last_modified_date, :location, :priority

      def initialize(location, last_modified_date, change_frequency, priority)
        @change_frequency = change_frequency
        @last_modified_date = last_modified_date
        @location = location
        @priority = priority
      end

      def to_liquid
        {
          "location" => location,
          "change_frequency" => change_frequency,
          "priority" => priority,
          "last_modified_date" => last_modified_date.iso8601,
        }
      end
    end
  end
end
