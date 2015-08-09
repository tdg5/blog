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
        while category = working.pop
          short_name = category_short_name(category)
          next if cat_map.key?(short_name)
          cat_map[short_name] = category
          parent_category = File.dirname(category)
          working << parent_category if parent_category != "."
        end
        sorted = {}
        cat_map.keys.sort!(&:casecmp).each do |name|
          sorted[name] = cat_map[name]
        end
        sorted
      end

      def markup
        cat_map = category_map(@categories)
        output = %Q[<p class="post-category">]
        links = cat_map.each_pair.map do |short_name, full_name|
          url = category_url(full_name)
          %Q[<a href="#{url}" rel="category tag">#{short_name}</a>]
        end
        output.concat(links.join(" / "))
        output.concat("</p>")
        output
      end
    end
  end
end

Liquid::Template.register_filter(JekyllHueman::FlatCategoriesFilter)
