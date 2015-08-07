module JekyllHueman
  module TagUtil
    def tag_url(tag, site = nil)
      config = site && site.respond_to?(:config) ? site.config : site
      dir = config && config["tag_dir"] || "/tag"
      sanitized_tag_name = tag.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_tag_name)
    end
  end
end
