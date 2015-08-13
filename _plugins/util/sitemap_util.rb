require_relative "config_util"

module JekyllHueman
  module SitemapUtil
    include ConfigUtil

    DEFAULT_SITEMAP_DIR = "/sitemap"

    def sitemap_dir
      simple_hueman_config["sitemap_dir"] || DEFAULT_SITEMAP_DIR
    end
  end
end
