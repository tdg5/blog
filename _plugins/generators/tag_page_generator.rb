require_relative "../pages/tag_page"

module JekyllHueman
  class TagPageGenerator < Jekyll::Generator
    def generate(site)
      return unless site.layouts.key?("tag_index")
      site.tags.each do |tag, posts|
        site.pages << TagPage.new(site, tag, posts)
      end
    end
  end
end
