require_relative "config_util"
require_relative "string_util"

module JekyllHueman
  module CategoryUtil
    include ConfigUtil
    include StringUtil

    def category_short_name(category)
      titleize(File.basename(category))
    end

    def category_url(category)
      dir = simple_hueman_config["category_dir"] || "/category"
      sanitized_cat_name = category.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_cat_name)
    end

    def hierarchify_categories(categories)
      hierarchical = Hash.new { |hash, key| hash[key] = [] }
      categories.each_pair do |category, posts|
        parent_category = category
        while parent_category != "."
          hierarchical[parent_category].concat(posts)
          parent_category = File.dirname(parent_category)
        end
      end
      sorted = {}
      keys = hierarchical.keys.sort_by { |cat| category_short_name(cat) }
      keys.each do |category|
        posts = hierarchical[category]
        posts.uniq!
        sorted[category] = posts.sort!.reverse!
      end
      sorted
    end
  end
end
