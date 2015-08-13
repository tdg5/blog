require_relative "../util/config_util"
require_relative "../util/sitemap_util"
require_relative "../util/sitemap/author_taxonomy"

module JekyllHueman
  class SitemapPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include SitemapUtil

    DEFAULT_LAYOUT = "sitemap".freeze

    attr_reader :sitemap_index_entry

    def self.layout_for_site(site)
      simple_hueman_config(site)["sitemap_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, name, taxonomy)
      @base = site.source
      @site = site

      @dir = sitemap_dir
      @name = "#{name}.xml"

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      self.data["entries"] = taxonomy.entries
      location = File.join(@site.config["url"], url)
      last_mod = taxonomy.last_modified_date
      @sitemap_index_entry = JekyllHueman::Sitemap::Entry.new(location, last_mod)
    end
  end
end
