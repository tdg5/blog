require_relative "config_util"

module JekyllHueman
  module SitemapUtil
    include ConfigUtil

    DEFAULT_SITEMAP_DIR = "/sitemap"

    def sitemap_dir
      simple_hueman_config["sitemap_dir"] || DEFAULT_SITEMAP_DIR
    end

    def sitemap_url(sitemap_name)
      File.join(site_config["url"], sitemap_dir, "#{sitemap_name}.xml")
    end
  end
end
