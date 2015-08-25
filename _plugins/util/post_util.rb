require_relative "url_util"

module JekyllHueman
  module PostUtil
    include URLUtil

    def pretty_post_slug_url(post_name)
      # PostUrl.new is private for some reason. I guess better to send then
      # duplicate logic?
      post_url_tag = Jekyll::Tags::PostUrl.send(:new, "ignore", post_name, [])
      pretty_url(post_url_tag.render(@context))
    end
  end
end
