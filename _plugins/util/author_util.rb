require_relative "config_util"

module JekyllHueman
  module AuthorUtil
    include ConfigUtil

    DEFAULT_AUTHOR_DIR = "/author".freeze

    def author_data(author)
      ((@site || @context.registers[:site]).data["authors"] || {})[author]
    end

    def author_url(author)
      dir = simple_hueman_config["author_dir"] || DEFAULT_AUTHOR_DIR
      sanitized_slug = author_data(author)["slug"].downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_slug)
    end
  end
end
