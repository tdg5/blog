require_relative "helper_accessors"

module JekyllHueman
  class BylineTag < Liquid::Tag
    include HelperAccessors

    def render(context)
      @context = context
      page = context.registers[:page]
      @author = author_data(page["author"])
      %Q[<p class="post-byline">by #{author_link} &middot; #{format_date(page["date"])}</p>]
    end

    private

    def author_link
      %Q[
        <a
          href="#{author_url}"
          rel="author"
          title="Posts by #{@author["name"]}"
        >
          #{@author["name"]}
        </a>
      ].gsub(/\n/, '').gsub(/ {2,}/, ' ')
    end

    def author_url
      "/author/#{@author["nickname"]}/"
    end

    def format_date(date)
      date.strftime("%B %d, %Y")
    end
  end
end
Liquid::Template.register_tag("byline", JekyllHueman::BylineTag)
