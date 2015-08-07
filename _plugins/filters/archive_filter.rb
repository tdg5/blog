require_relative "../util/archive_util"

module JekyllHueman
  module ArchiveFilter
    include ArchiveUtil

    def posts_by_year_and_month(*)
      super
    end
  end
end

Liquid::Template.register_filter(JekyllHueman::ArchiveFilter)
