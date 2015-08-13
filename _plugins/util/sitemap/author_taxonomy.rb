require_relative "taxonomy"
require_relative "../author_util"
require_relative "entry"

module JekyllHueman
  module Sitemap
    class AuthorTaxonomy < Taxonomy
      include JekyllHueman::AuthorUtil

      def entries
        authors.map! do |author|
          location = File.join(site_url, author_url(author))
          last_modified_date = nil
          author_posts[author].each do |post|
            next if last_modified_date && last_modified_date > post.date
            last_modified_date = post.date
          end
          change_frequency = "monthly"
          priority = 0.7
          Entry.new(location, last_modified_date, change_frequency, priority)
        end
      end

      def to_liquid
        raise NotImplementedError, "TODO"
      end

      private

      def authors
        author_posts.keys
      end

      def site_url
        @site_url ||= @site.config["url"]
      end
    end
  end
end
