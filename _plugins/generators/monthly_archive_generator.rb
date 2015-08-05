require_relative "../util/archive_util"

module JekyllHueman
  class MonthlyArchivePage < Jekyll::Page
    include JekyllHueman::ArchiveUtil

    CALENDAR_ICON = %q[<i class="fa fa-calendar"></i>].freeze

    def initialize(site, date, posts)
      @name = "index.html"
      @site = site
      @base = site.source
      @dir = archive_url(date)

      self.process(@name)
      self.read_yaml(File.join(site.source, "_layouts"), "monthly_archive.html")

      month_year = date.strftime("%B %Y")
      self.data["header_title"] = "#{CALENDAR_ICON}Monthly Archive:&nbsp;<span>#{month_year}</span>"
      self.data["posts"] = posts
      self.data["title"] = "#{month_year} Archives"
    end
  end

  class MonthlyArchiveGenerator < Jekyll::Generator
    include JekyllHueman::ArchiveUtil

    def generate(site)
      return unless site.layouts.key?("monthly_archive")
      posts_by_year_and_month(site.posts).each do |date, posts|
        site.pages << MonthlyArchivePage.new(site, date, posts)
      end
    end
  end
end
