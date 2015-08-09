require_relative "config_util"

module JekyllHueman
  module ArchiveUtil
    include ConfigUtil

    def archive_url(date)
      dir = simple_hueman_config["monthly_archive_dir"] || "/%04d/%02d"
      File.join(dir % [date.year, date.month])
    end

    def posts_by_year_and_month(posts)
      grps = posts.group_by { |post| Date.new(post.date.year, post.date.month) }
      Hash[grps.sort_by(&:first).reverse]
    end
  end
end
