require_relative "../pages/tag_page"

module JekyllHueman
  class SiteMapGenerator < Jekyll::Generator
    def generate(site)
      return if !site.layouts.key?(SitemapPage.layout_for_site(site)) ||
        !site.layouts.key?(SitemapIndexPage.layout_for_site(site))

      #categories_sitemap = SitemapPage.new(site.categories)
      #posts_sitemap = SitemapPage.new(site.posts)
      author_sitemap = SitemapPage.new(site)
      #tags_sitemap = SitemapPage.new(site.tags)
      sitemap_index = SitemapIndexPage.new(site, [
        author_sitemap,
        #categories_sitemap,
        #posts_sitemap,
        #tags_sitemap,
      ])

      site.pages.concat([
        author_sitemap,
        #categories_sitemap,
        #posts_sitemap,
        sitemap_index,
        #tags_sitemap,
      ])
    end
  end
end
