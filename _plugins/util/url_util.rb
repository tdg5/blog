require_relative "../util/config_util"

module JekyllHueman
  module URLUtil
    include ConfigUtil

    def absolute_url(url = "")
      File.join(site_config["url"], url)
    end

    def post_image_url(image_name, page = nil)
      page_date = page ? page.date : @context.registers[:page]["date"]
      page_date = page_date.strftime("%Y-%m-%d")
      File.join("/assets/images/posts/", page_date, image_name)
    end

    def short_url(url = "")
      short = File.dirname(url)
      short == "." ? url : short
    end
  end
end

