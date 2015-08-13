require_relative "../pages/tag_page"

module JekyllHueman
  class SiteMapGenerator < Jekyll::Generator
    def generate(site)
      return if !site.layouts.key?(SitemapPage.layout_for_site(site)) ||
        !site.layouts.key?(SitemapIndexPage.layout_for_site(site))

      author_taxonomy = JekyllHueman::Sitemap::AuthorTaxonomy.new(site)
      author_sitemap = SitemapPage.new(site, "authors", author_taxonomy)
      category_taxonomy = JekyllHueman::Sitemap::CategoryTaxonomy.new(site)
      categories_sitemap = SitemapPage.new(site, "categories", category_taxonomy)
      post_taxonomy = JekyllHueman::Sitemap::PostTaxonomy.new(site)
      posts_sitemap = SitemapPage.new(site, "posts", post_taxonomy)
      tag_taxonomy = JekyllHueman::Sitemap::TagTaxonomy.new(site)
      tags_sitemap = SitemapPage.new(site, "tags", tag_taxonomy)
      sitemap_index = SitemapIndexPage.new(site, [
        author_sitemap.sitemap_index_entry,
        categories_sitemap.sitemap_index_entry,
        posts_sitemap.sitemap_index_entry,
        tags_sitemap.sitemap_index_entry,
      ])

      site.pages.concat([
        author_sitemap,
        categories_sitemap,
        posts_sitemap,
        sitemap_index,
        tags_sitemap,
      ])
    end
  end
end
