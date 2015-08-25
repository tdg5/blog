require_relative "../util/archive_util"
require_relative "../util/author_util"
require_relative "../util/category_util"
require_relative "../util/gravatar_util"
require_relative "../util/post_util"
require_relative "../util/rss_util"
require_relative "../util/share_util"
require_relative "../util/sitemap_util"
require_relative "../util/tag_util"
require_relative "../util/url_util"

module JekyllHueman
  module URLHelperFilter
    include(*[
      ArchiveUtil,
      AuthorUtil,
      CategoryUtil,
      GravatarUtil,
      PostUtil,
      RSSUtil,
      ShareUtil,
      SitemapUtil,
      TagUtil,
      URLUtil,
    ])

    def initialize(context)
      @context = context
      super if defined?(super)
    end

    def absolute_url(*); super; end
    def archive_url(*); super; end
    def author_url(*); super; end
    def category_url(*); super; end
    def gravatar_avatar_url(*); super; end
    def pretty_url(*); super; end
    def pretty_post_slug_url(*); super; end
    def post_image_url(*); super; end
    def rss_url(*); super; end
    def sitemap_url(*); super; end
    def tag_url(*); super; end

    # Share URL helpers
    def facebook_share_url(*); super; end
    def google_plus_share_url(*); super; end
    def linkedin_share_url(*); super; end
    def twitter_share_url(*); super; end
  end
end

Liquid::Template.register_filter(JekyllHueman::URLHelperFilter)
