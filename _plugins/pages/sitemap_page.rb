require_relative "../util/config_util"
require_relative "../util/sitemap_util"
require_relative "../util/sitemap/author_taxonomy"

module JekyllHueman
  class SitemapPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include SitemapUtil

    DEFAULT_LAYOUT = "sitemap".freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["sitemap_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site)
      @base = site.source
      @site = site

      @dir = sitemap_dir
      @name = "authors.xml"

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      taxonomy = JekyllHueman::Sitemap::AuthorTaxonomy.new(@site)
      self.data["entries"] = taxonomy.entries
    end
  end
end
