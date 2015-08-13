require_relative "taxonomy"
require_relative "entry"
require_relative "../author_util"

module JekyllHueman
  module Sitemap
    class AuthorTaxonomy < Taxonomy
      include JekyllHueman::AuthorUtil

      def entries
        taxonomy_last_modified_date = nil
        entries = author_posts.map do |author, posts|
          location = File.join(site_url, author_url(author))
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
