module JekyllHueman
  module AuthorUtil
    def author_data(author, site)
      (site["data"]["authors"] || {})[author]
    end

    def author_url(author, site)
      config = site && site.respond_to?(:config) ? site.config : site
      dir = config && config["author_dir"] || "/author"
      name = author_data(author, site)["nickname"]
      sanitized_name = name.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_name)
    end
  end
end
