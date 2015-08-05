module JekyllHueman
  class TitleTag < Liquid::Tag
    def render(context)
      @context = context
      page_title || site_title_and_tagline
    end

    private

    def page_title
      page = @context.registers[:page]
      title = page["meta_title"] || page["title"]
      "#{title} - #{site_title}" if title
    end

    def site_title
      @context.registers[:site].config["title"]
    end

    def site_title_and_tagline
      tagline = @context.registers[:site].config["tagline"]
      site_title + (tagline ? " - #{tagline}" : "")
    end
  end
end

Liquid::Template.register_tag("title", JekyllHueman::TitleTag)
