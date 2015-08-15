require_relative "config_util"

module JekyllHueman
  module RSSUtil
    include ConfigUtil

    DEFAULT_RSS_DIR = "/feed".freeze

    def rss_dir
      simple_hueman_config["rss_dir"] || DEFAULT_RSS_DIR
    end

    def rss_url(feed_name)
      File.join(rss_dir, feed_name)
    end
  end
end
