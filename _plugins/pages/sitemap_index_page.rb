require_relative "../util/config_util"
require_relative "../util/sitemap_util"

module JekyllHueman
  class SitemapIndexPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include SitemapUtil

    DEFAULT_LAYOUT = "sitemap_index".freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["sitemap_index_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, sitemap_index_entries)
      @base = site.source
      @site = site

      @dir = sitemap_dir
      @name = "index.xml"

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      self.data["sitemap_index_entries"] = sitemap_index_entries
    end
  end
end
