require_relative "../util/archive_util"
require_relative "../util/config_util"

module JekyllHueman
  class MonthlyArchivePage < Jekyll::Page
    extend ConfigUtil
    include ConfigUtil
    include ArchiveUtil

    DEFAULT_LAYOUT = "monthly_archive".freeze
    DEFAULT_TITLE_PREFIX = "Monthly Archive: ".freeze
    CALENDAR_ICON = %q[<i class="fa fa-calendar"></i>].freeze

    def self.layout_for_site(site)
      simple_hueman_config(site)["monthly_archive_page_layout"] || DEFAULT_LAYOUT
    end

    def initialize(site, date, posts)
      @base = site.source
      @context = Liquid::Context.new({}, {}, { :site => site })
      @dir = archive_url(date)
      @name = "index.html"
      @site = site

      process(@name)
      layout = site.layouts[self.class.layout_for_site(@site)]
      read_yaml(File.dirname(layout.path), File.basename(layout.path))

      month_year = date.strftime("%B %Y")
      title_prefix = simple_hueman_config["monthly_archive_title_prefix"] || DEFAULT_TITLE_PREFIX
      date_span = "<span>#{month_year}</span>"
      self.data["header_title"] = "#{CALENDAR_ICON}#{title_prefix}#{date_span}"
      self.data["posts"] = posts
      self.data["title"] = "#{month_year} Archives"
    end
  end
end
