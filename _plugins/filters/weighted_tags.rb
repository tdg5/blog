require "digest"

require_relative "../util/weighted_tags_util"

module JekyllHueman
  module WeightedTagsFilter
    include JekyllHueman::WeightedTagsUtil

    def weighted_tags_for_posts(*)
      super
    end
  end
end

Liquid::Template.register_filter(JekyllHueman::WeightedTagsFilter)
