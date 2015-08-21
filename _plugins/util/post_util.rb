require_relative "url_util"

module JekyllHueman
  module PostUtil
    include URLUtil

    def pretty_post_url(url)
      short = short_url(url)
      short.concat("/") unless short[-1] == "/"
      short
    end
  end
end
