require_relative "../util/archive_util"
require_relative "../util/author_util"
require_relative "../util/category_util"
require_relative "../util/tag_util"

module JekyllHueman
  module URLHelperFilter
    include ArchiveUtil, AuthorUtil, CategoryUtil, TagUtil

    def archive_url(*); super; end
    def author_url(*); super; end
    def category_url(*); super; end
    def tag_url(*); super; end
  end
end

Liquid::Template.register_filter(JekyllHueman::URLHelperFilter)
