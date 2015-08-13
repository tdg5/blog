module JekyllHueman
  module Sitemap
    class Taxonomy
      attr_reader :last_modified_date

      def entries
        msg = "#entries must be defined by #{self.class.name} subclass!"
        raise NotImplementedError, msg
      end

      def initialize(site)
        @site = site
      end

      def last_modified
        return @last_modified_date if @last_modified_date
        # Last modified date is determined as a side effect of scanning the list
        # of entries.
        entries
        @last_modified_date
      end

      private

      def first_and_last_modified_dates(posts)
        last_modified_date = first_modified_date = nil
        posts.each do |post|
          if first_modified_date.nil? || post.date < first_modified_date
            first_modified_date = post.date
          end
          if last_modified_date.nil? || post.date > last_modified_date
            last_modified_date = post.date
          end
        end
        [first_modified_date, last_modified_date]
      end

      def site_url
        @site_url ||= @site.config["url"]
      end
    end
  end
end
