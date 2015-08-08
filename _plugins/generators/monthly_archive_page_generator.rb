require_relative "../util/archive_util"
require_relative "../pages/monthly_archive_page"

module JekyllHueman
  class MonthlyArchiveGenerator < Jekyll::Generator
    include JekyllHueman::ArchiveUtil

    def generate(site)
      layout = MonthlyArchivePage.layout_for_site(site)
      return unless site.layouts.key?(layout)
      posts_by_year_and_month(site.posts).each do |date, posts|
        site.pages << MonthlyArchivePage.new(site, date, posts)
      end
    end
  end
end
