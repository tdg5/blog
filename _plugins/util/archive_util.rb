module JekyllHueman
  module ArchiveUtil
    def archive_url(date, site = nil)
      config = site && site.respond_to?(:config) ? site.config : site
      dir = config && config["archive_dir"] || "/%04d/%02d"
      File.join(dir % [date.year, date.month])
    end

    def posts_by_year_and_month(posts)
      posts.group_by { |post| Date.new(post.date.year, post.date.month) }
    end
  end
end
