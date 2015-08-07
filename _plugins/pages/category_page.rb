require_relative "../util/category_util"

module JekyllHueman
  class CategoryPage < Jekyll::Page
    include CategoryUtil

    FOLDER_ICON = %q[<i class="fa fa-folder-open"></i>].freeze

    def initialize(site, category, sub_categories)
      @site = site
      @base = site.source
      @dir = category_url(category, site)
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, "_layouts"), "category_index.html")

      category_posts = sub_categories.flat_map {|sub_cat| site.categories[sub_cat] }
      category_title_prefix = site.config["category_title_prefix"] || "Category: "
      name_span = "<span>#{File.basename(category)}</span>"
      header_title = "#{FOLDER_ICON}#{category_title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = category_posts.uniq.sort.reverse
      self.data["title"] = "#{File.basename(category)} Archives"
    end
  end
end
