require_relative "taxonomy"
require_relative "entry"
require_relative "../tag_util"

module JekyllHueman
  module Sitemap
    class TagTaxonomy < Taxonomy
      include JekyllHueman::TagUtil

      def entries
        taxonomy_last_modified_date = nil
        entries = @site.tags.map do |tag, posts|
          location = File.join(site_url, tag_url(tag))
          first_modified_date, last_modified_date = first_and_last_modified_dates(posts)
          change_frequency = "monthly"
          priority = 0.7
          if taxonomy_last_modified_date.nil? || first_modified_date > taxonomy_last_modified_date
            taxonomy_last_modified_date = first_modified_date
          end
          Entry.new(location, last_modified_date, change_frequency, priority)
        end
        @last_modified_date = taxonomy_last_modified_date
        entries
      end
    end
  end
end
