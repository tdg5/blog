require_relative "../util/config_util"

module JekyllHueman
  module URLUtil
    include ConfigUtil

    UGLY_URL_MATCHER = /\/index.html$/

    def absolute_url(url = "")
      File.join(site_config["url"], url)
    end

    def post_image_url(image_name, page = nil)
      page_date = page ? page.date : @context.registers[:page]["date"]
      page_date = page_date.strftime("%Y-%m-%d")
      File.join("/assets/images/posts/", page_date, image_name)
    end

    def pretty_absolute_url(url)
      absolute_url(pretty_url(url))
    end

    def pretty_url(url)
      return url unless UGLY_URL_MATCHER === url
      short = short_url(url)
      short.concat("/") unless short[-1] == "/"
      short
    end

    def short_url(url = "")
      short = File.dirname(url)
      short == "." ? url : short
    end
  end
end

