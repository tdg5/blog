require_relative "../util/author_util"
require_relative "../util/config_util"

module JekyllHueman
  class AuthorPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include AuthorUtil

    DEFAULT_LAYOUT = "author_index".freeze
    DEFAULT_TITLE_PREFIX = "Author: ".freeze
    USER_ICON = %q[<i class="fa fa-user"></i>].freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["author_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, author, posts)
      @site = site
      @base = site.source
      @context = Liquid::Context.new({}, {}, { :site => @site })
      @dir = author_url(author)
      @name = "index.html"
      author = author_data(author)

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      title_prefix = simple_hueman_config["author_title_prefix"] || DEFAULT_TITLE_PREFIX
      name_span = "<span>#{author["name"]}</span>"
      header_title = "#{USER_ICON}#{title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = posts.sort.reverse
      self.data["title"] = "#{author["name"]} Archives"
    end
  end
end
