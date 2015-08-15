require_relative "../pages/rss_page"
require_relative "../util/author_util"

module JekyllHueman
  class RSSPageGenerator < Jekyll::Generator
    include AuthorUtil

    def generate(site)
      @site = site
      site.pages << RSSPage.new(site, "", site.posts)
      author_posts(site).each do |author, posts|
        slug = author_data(author)["slug"]
        site.pages << RSSPage.new(site, slug, posts)
      end
    end
  end
end
