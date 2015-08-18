require_relative "../util/weighted_tags_util"

module JekyllHueman
  module WeightedTagsFilter
    include WeightedTagsUtil

    def initialize(context)
      @context = context
      super if defined?(super)
    end

    def weighted_tags_for_posts(*); super; end
  end
end

Liquid::Template.register_filter(JekyllHueman::WeightedTagsFilter)
