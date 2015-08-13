module JekyllHueman
  module Sitemap
    class Taxonomy
      def entries
        raise NotImplementedError, "#entries must be defined by subclass!"
      end

      def initialize(site)
        @site = site
      end
    end
  end
end
