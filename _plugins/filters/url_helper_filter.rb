require_relative "../util/archive_util"
require_relative "../util/author_util"
require_relative "../util/category_util"
require_relative "../util/post_util"
require_relative "../util/sitemap_util"
require_relative "../util/tag_util"
require_relative "../util/url_util"

module JekyllHueman
  module URLHelperFilter
    include(*[
      ArchiveUtil,
      AuthorUtil,
      CategoryUtil,
      PostUtil,
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
    def post_url(*); super; end
    def sitemap_url(*); super; end
    def tag_url(*); super; end
  end
end

Liquid::Template.register_filter(JekyllHueman::URLHelperFilter)
