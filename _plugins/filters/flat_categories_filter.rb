require_relative "../util/category_util"

module JekyllHueman
  module FlatCategoriesFilter
    def initialize(context)
      @context = context
      super if defined?(super)
    end

    def flat_categories(categories)
      Factory.new(categories, @context).markup
    end

    class Factory
      include CategoryUtil

      def initialize(categories, context)
        @categories, @context = categories, context
      end

      def category_map(categories)
        cat_map = {}
        working = categories.dup
        until working.empty?
          category = working.pop
          next if cat_map.key?(category)
          cat_map[File.basename(category)] = category
          parent_category = File.dirname(category)
          working << parent_category if parent_category != "."
        end
        cat_map
      end

      def markup
        cat_map = category_map(@categories)
        names = cat_map.keys.sort(&:casecmp)
        output = %Q[<p class="post-category">]
        links = names.map do |name|
          url = category_url(cat_map[name])
          %Q[<a href="#{url}" rel="category tag">#{name}</a>]
        end
        output.concat(links.join(" / "))
        output.concat("</p>")
        output
      end
    end
  end
end

Liquid::Template.register_filter(JekyllHueman::FlatCategoriesFilter)
