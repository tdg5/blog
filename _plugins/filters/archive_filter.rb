require_relative "../util/archive_util"

module JekyllHueman
  module ArchiveFilter
    include JekyllHueman::ArchiveUtil

    def archive_url(*)
      super
    end

    def posts_by_year_and_month(*)
      super
    end
  end
end

Liquid::Template.register_filter(JekyllHueman::ArchiveFilter)
