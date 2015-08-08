require_relative "../util/author_util"

module JekyllHueman
  class AuthorPage < Jekyll::Page
    include AuthorUtil

    USER_ICON = %q[<i class="fa fa-user"></i>].freeze

    def initialize(site, author, posts)
      @site = site
      @base = site.source
      @dir = author_url(author, site)
      @name = "index.html"
      author = author_data(author, site)

      self.process(@name)
      self.read_yaml(File.join(@base, "_layouts"), "author_index.html")

      author_title_prefix = site.config["author_title_prefix"] || "Author: "
      name_span = "<span>#{author["name"]}</span>"
      header_title = "#{USER_ICON}#{author_title_prefix}#{name_span}"

      self.data["header_title"] = header_title
      self.data["posts"] = posts.sort.reverse
      self.data["title"] = "#{author["name"]} Archives"
    end
  end
end
