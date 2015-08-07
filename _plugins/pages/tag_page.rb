require_relative "../util/tag_util"

module JekyllHueman
  class TagPage < Jekyll::Page
    include JekyllHueman::TagUtil

    TAG_ICON = %q[<i class="fa fa-tags"></i>].freeze

    def initialize(site, tag, posts)
      @site = site
      @base = site.source
      @dir = tag_url(tag, site)
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, "_layouts"), "tag_index.html")

      name_span = "<span>#{tag}</span>"
      tag_title_prefix = site.config["tag_title_prefix"] || "Tagged: "
      header_title = "#{TAG_ICON}#{tag_title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = posts
      self.data["tag"] = tag
      self.data["title"] = "#{tag} Archives"
    end
  end
end
