require_relative "../util/config_util"
require_relative "../util/category_util"

module JekyllHueman
  class CategoryPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include CategoryUtil

    DEFAULT_LAYOUT = "category_index".freeze
    DEFAULT_TITLE_PREFIX = "Category: ".freeze
    FOLDER_ICON = %q[<i class="fa fa-folder-open"></i>].freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["category_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, category, sub_categories)
      @site = site
      @base = site.source
      @context = Liquid::Context.new({}, {}, { :site => site })
      @dir = category_url(category)
      @name = "index.html"

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      category_posts = sub_categories.flat_map {|sub_cat| site.categories[sub_cat] }
      title_prefix = simple_hueman_config["category_title_prefix"] || DEFAULT_TITLE_PREFIX
      name_span = "<span>#{File.basename(category)}</span>"
      header_title = "#{FOLDER_ICON}#{title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = category_posts.uniq.sort.reverse
      self.data["title"] = "#{File.basename(category)} Archives"
    end
  end
end
