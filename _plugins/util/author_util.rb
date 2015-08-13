require_relative "config_util"

module JekyllHueman
  module AuthorUtil
    include ConfigUtil

    DEFAULT_AUTHOR_DIR = "/author".freeze
    LIST_HASH_PROC = lambda { |h, k| h[k] = [] }

    def author_data(author)
      ((@site || @context.registers[:site]).data["authors"] || {})[author]
    end

    def author_posts(site = @site)
      posts = Hash.new(&LIST_HASH_PROC)
      site.posts.each { |post| posts[post.data["author"]] << post }
      posts
    end

    def author_url(author)
      dir = simple_hueman_config["author_dir"] || DEFAULT_AUTHOR_DIR
      sanitized_slug = author_data(author)["slug"].downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_slug)
    end
  end
end
