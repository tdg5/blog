require_relative "../util/config_util"
require_relative "../util/tag_util"

module JekyllHueman
  class TagPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include TagUtil

    DEFAULT_LAYOUT = "tag_index".freeze
    DEFAULT_TITLE_PREFIX = "Tagged: ".freeze
    TAG_ICON = %q[<i class="fa fa-tags"></i>].freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["tag_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, tag, posts)
      @base = site.source
      @site = site

      @dir = tag_url(tag)
      @name = "index.html"

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      name_span = "<span>#{tag}</span>"
      tag_title_prefix = simple_hueman_config["tag_title_prefix"] || DEFAULT_TITLE_PREFIX
      header_title = "#{TAG_ICON}#{tag_title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = posts
      self.data["tag"] = tag
      self.data["title"] = "#{tag} Archives"
    end
  end
end
