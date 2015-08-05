require "set"

module JekyllHueman
  class CategoryPage < Jekyll::Page
    FOLDER_ICON = %q[<i class="fa fa-folder-open"></i>].freeze

    def initialize(site, base, dir, category, sub_categories)
      @site = site
      @base = base
      @dir = dir
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "category_index.html")

      category_posts = sub_categories.flat_map {|sub_cat| site.categories[sub_cat] }
      category_title_prefix = site.config["category_title_prefix"] || "Category: "
      name_span = "<span>#{File.basename(category)}</span>"
      header_title = "#{FOLDER_ICON}#{category_title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = category_posts.uniq.sort.reverse
      self.data["title"] = "#{File.basename(category)} Archives"
    end
  end

  class CategoryPageGenerator < Jekyll::Generator
    def generate(site)
      return unless site.layouts.key?("category_index")
      dir = site.config["category_dir"] || "category"

      categories(site).each_pair do |category, sub_categories|
        cat_path = File.join(dir, category).gsub(/\s+/, '-')
        site.pages << CategoryPage.new(site, site.source, cat_path, category, sub_categories)
      end
    end

    def categories(site)
      categories = Hash.new { |hash, key| hash[key] = [] }
      site.categories.each_key do |category|
        categories[category] << category
        sub_categories = category.split(/\//)
        sub_categories.pop
        until sub_categories.empty?
          categories[sub_categories.join("/")] << category
          sub_categories.pop
        end
      end
      categories
    end
  end
end
