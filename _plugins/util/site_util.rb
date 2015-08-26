require_relative "config_util"

module JekyllHueman
  module SiteUtil
    include ConfigUtil

    def site_id
      site_config["name"] || URI(site_config["url"]).host
    end
  end
end
