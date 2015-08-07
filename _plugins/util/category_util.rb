module JekyllHueman
  module CategoryUtil
    def category_url(category, site = nil)
      config = site && site.respond_to?(:config) ? site.config : site
      dir = config && config["category_dir"] || "/category"
      sanitized_cat_name = category.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_cat_name)
    end
  end
end
