require_relative "../util/config_util"

module JekyllHueman
  module URLUtil
    include ConfigUtil

    def absolute_url(url = "")
      File.join(site_config["url"], url)
    end

    def short_url(url = "")
      short = File.dirname(url)
      short == "." ? url : short
    end
  end
end

