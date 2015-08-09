require_relative "../util/category_util"
require_relative "../pages/category_page"

module JekyllHueman
  class CategoryPageGenerator < Jekyll::Generator
    include CategoryUtil

    def generate(site)
      layout = CategoryPage.layout_for_site(site)
      return unless site.layouts.key?(layout)
      hierarchify_categories(site.categories).each_pair do |category, posts|
        site.pages << CategoryPage.new(site, category, posts)
      end
    end
  end
end
