require_relative "taxonomy"
require_relative "entry"
require_relative "../category_util"

module JekyllHueman
  module Sitemap
    class CategoryTaxonomy < Taxonomy
      include JekyllHueman::CategoryUtil

      def entries
        taxonomy_last_modified_date = nil
        entries = hierarchify_categories(@site.categories).map do |category, posts|
          location = File.join(site_url, category_url(category))
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
