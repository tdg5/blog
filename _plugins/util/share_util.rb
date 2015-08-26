require_relative "author_util"
require_relative "config_util"
require_relative "url_util"
require "cgi"
require "uri"

module JekyllHueman
  module ShareUtil
    include Liquid::StandardFilters
    include AuthorUtil
    include ConfigUtil
    include URLUtil

    QUERY_STRING_AMP = "&".freeze
    QUERY_STRING_EQL = "=".freeze
    SHARE_FACEBOOK_URI = URI("https://www.facebook.com/dialog/share").freeze
    SHARE_GOOGLE_PLUS_URI = URI("https://plus.google.com/share").freeze
    SHARE_HACKER_NEWS_URI = URI("http://news.ycombinator.com/submitlink").freeze
    SHARE_REDDIT_URI = URI("http://www.reddit.com/submit").freeze
    SHARE_TWITTER_URI = URI("https://twitter.com/intent/tweet").freeze
    SHARE_LINKEDIN_URI = URI("https://www.linkedin.com/shareArticle").freeze

    # https://developers.facebook.com/docs/sharing/reference/share-dialog
    def facebook_share_url(page)
      query = {
        "app_id" => site_config["social"]["facebook_app_id"],
        "display" => "popup",
        "href" => page_absolute_url(page),
        "redirect_uri" => thanks_for_sharing_url,
      }
      share_url(:facebook, query)
    end

    # https://developers.google.com/+/web/share/
    def google_plus_share_url(page)
      query = {
        "url" => page_absolute_url(page)
      }
      share_url(:google_plus, query)
    end

    # https://news.ycombinator.com/bookmarklet.html
    def hacker_news_share_url(page)
      query = {
        "u" => page_absolute_url(page),
        "t" => page_title(page),
      }
      share_url(:hacker_news, query)
    end

    # https://developer.linkedin.com/docs/share-on-linkedin
    def linkedin_share_url(page)
      query = {
        "mini" => "true",
        "url" => page_absolute_url(page),
        "title" => page_title(page),
        "summary" => page_description(page),
        "source" => site_url,
      }
      share_url(:linkedin, query)
    end

    # https://www.reddit.com/wiki/submitting#wiki_tips_and_tricks
    def reddit_share_url(page)
      query = {
        "title" => page_title(page),
        "url" => page_absolute_url(page),
      }
      share_url(:reddit, query)
    end

    # https://dev.twitter.com/web/tweet-button
    def twitter_share_url(page)
      via_name = author_data(page["author"])["twitter_usename"]
      via_name ||= site_config["social"]["twitter_username"]
      query = {
        "text" => "Check out #{page_title(page)}",
        "url" => page_absolute_url(page),
      }
      query["via"] = via_name if via_name
      share_url(:twitter, query)
    end

    private

    def base_uri(type)
      case type
        when :facebook then SHARE_FACEBOOK_URI.dup
        when :google_plus then SHARE_GOOGLE_PLUS_URI.dup
        when :hacker_news then SHARE_HACKER_NEWS_URI.dup
        when :linkedin then SHARE_LINKEDIN_URI.dup
        when :reddit then SHARE_REDDIT_URI.dup
        when :twitter then SHARE_TWITTER_URI.dup
      end
    end

    def build_query_string(params)
      query = ""
      params.each do |key, value|
        query.concat(QUERY_STRING_AMP) unless query.empty?
        query.concat(URI.escape(key))
        query.concat(QUERY_STRING_EQL)
        query.concat(URI.escape(value))
      end
      query
    end

    def page_absolute_url(page)
      pretty_absolute_url(page["url"])
    end

    def page_description(page)
      if page_desc = page["description"]
        page_desc
      elsif excerpt = page["excerpt"]
        excerpt_text = CGI.unescape_html(strip_html(excerpt))
        truncate(excerpt_text, 256)
      elsif site_desc = site_config["description"]
        site_desc
      end
    end

    def page_title(page)
      page["title"] ? page["title"] : site_config["title"]
    end

    def share_url(type, params)
      uri = base_uri(type)
      uri.query = build_query_string(params)
      uri.to_s
    end

    def thanks_for_sharing_url
      if @context
        page = @context.registers[:site].pages.find do |p|
          p.name == "share_thanks.html"
        end
        url = pretty_absolute_url(page.url) if page
      end
      url || site_url
    end

    def site_url
      site_config["url"]
    end
  end
end
