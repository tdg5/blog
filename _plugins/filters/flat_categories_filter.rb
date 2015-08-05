module JekyllHueman
  module FlatCategoriesFilter
    def flat_categories(categories)
      FlatCategoriesFactory.new(categories).markup
    end
  end

  class FlatCategoriesFactory
    def initialize(categories)
      @categories = categories
    end

    def category_map(categories)
      cat_map = {}
      working = categories.dup
      until working.empty?
        category = working.pop
        next if cat_map.key?(category)
        cat_map[File.basename(category)] = category
        dirname = File.dirname(category)
        working << dirname unless dirname == "."
      end
      cat_map
    end

    def markup
      cat_map = category_map(@categories)
      names = cat_map.keys.sort
      output = %Q[<p class="post-category">]
      links = names.map do |name|
        url = category_url(cat_map[name])
        %Q[<a href="#{url}" rel="category tag">#{name}</a>]
      end
      output.concat(links.join(" / "))
      output.concat("</p>")
      output
    end

    def category_url(category)
      File.join("/category", category.gsub(/\s+/, "-"))
    end
  end
end

Liquid::Template.register_filter(JekyllHueman::FlatCategoriesFilter)
