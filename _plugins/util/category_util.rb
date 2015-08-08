require_relative "config_util"

module JekyllHueman
  module CategoryUtil
    include ConfigUtil

    def category_url(category)
      dir = simple_hueman_config["category_dir"] || "/category"
      sanitized_cat_name = category.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_cat_name)
    end
  end
end
