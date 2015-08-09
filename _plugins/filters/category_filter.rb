require_relative "../util/category_util"

module JekyllHueman
  module CategoryFilter
    include CategoryUtil

    def category_short_name(*); super; end
    def hierarchify_categorieS(*); super; end
  end
end

Liquid::Template.register_filter(JekyllHueman::CategoryFilter)
