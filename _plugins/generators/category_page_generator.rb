require_relative "../pages/category_page"

module JekyllHueman
  class CategoryPageGenerator < Jekyll::Generator
    def generate(site)
      layout = CategoryPage.layout_for_site(site)
      return unless site.layouts.key?(layout)
      categories(site).each_pair do |category, sub_categories|
        site.pages << CategoryPage.new(site, category, sub_categories)
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
