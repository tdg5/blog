module JekyllHueman
  module ArchiveUtil
    def archive_url(date)
      File.join("/", "%04d/%02d" % [date.year, date.month])
    end

    def posts_by_year_and_month(posts)
      posts.group_by { |post| Date.new(post.date.year, post.date.month) }
    end
  end
end
