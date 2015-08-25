require_relative "taxonomy"
require_relative "entry"
require_relative "../post_util"

module JekyllHueman
  module Sitemap
    class PostTaxonomy < Taxonomy
      include PostUtil

      def entries
        taxonomy_last_modified_date = nil
        entries = @site.posts.map do |post|
          location = absolute_url(pretty_url(post.url))
          first_modified_date = last_modified_date = post.date
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
