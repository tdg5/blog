require_relative "../util/config_util"
require_relative "../util/rss_util"
require "cgi/util"
require "rss"

module JekyllHueman
  class RSSPage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include RSSUtil

    DEFAULT_LAYOUT = "rss".freeze
    HTML_ESCAPING = /<\/?[^>]+?>/.freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["rss_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, name, posts)
      @site = site
      @base = site.source
      @dir = File.join(rss_dir, name)
      @name = "index.html"

      process(@name)

      self.content = render_rss(name, posts)
      self.data = { "regenerate" => true }
    end

    private

    def render_rss(name, posts)
      rss = RSS::Maker.make("2.0") do |maker|
        maker.channel.author = wrap_cdata(site.config["author"])
        maker.channel.copyright = wrap_cdata(site.config["copyright"])
        maker.channel.description = wrap_cdata(site.config["description"])
        maker.channel.link = site.config["url"]
        maker.channel.title = wrap_cdata(site.config["title"])

        post_limit = simple_hueman_config["rss_item_limit"]
        count = 0
        posts.sort.reverse_each do |post|
          break if post_limit && count == post_limit
          maker.channel.updated = post.date if maker.channel.updated.nil?
          post = post.dup
          post.render(site.layouts, site.site_payload)
          maker.items.new_item do |item|
            post_url = File.join(site.config["url"], post.url)
            item.content_encoded = wrap_cdata(post.content)
            item.description = wrap_cdata(post.excerpt.gsub(HTML_ESCAPING, ""))
            item.guid.content = post_url
            item.link = post_url
            item.title = post.title
            item.updated = post.date
          end
          count += 1
        end
      end
      CGI.unescapeHTML(rss.to_s)
    end

    def wrap_cdata(cdata)
      "<![CDATA[" + cdata + "]]>"
    end
  end
end
