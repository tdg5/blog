require_relative "config_util"

module JekyllHueman
  module TagUtil
    include ConfigUtil

    DEFAULT_TAG_DIR = "/tag".freeze

    def tag_url(tag)
      dir = simple_hueman_config["tag_dir"] || DEFAULT_TAG_DIR
      sanitized_tag_name = tag.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_tag_name)
    end
  end
end
