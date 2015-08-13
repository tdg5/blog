require_relative "../pages/author_page"
require_relative "../util/author_util"

module JekyllHueman
  class AuthorPageGenerator < Jekyll::Generator
    include AuthorUtil

    def generate(site)
      layout = AuthorPage.layout_for_site(site)
      return unless site.layouts.key?(layout)
      author_posts(site).each_pair do |author, posts|
        site.pages << AuthorPage.new(site, author, posts)
      end
    end
  end
end
