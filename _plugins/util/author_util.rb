module JekyllHueman
  module AuthorUtil
    def author_data(author, site = nil)
      data = site && site.respond_to?(:data) ? site.data : site["data"]
      (data["authors"] || {})[author]
    end

    def author_url(author, site = nil)
      config = site && site.respond_to?(:config) ? site.config : site
      dir = config && config["author_dir"] || "/author"
      slug = author_data(author, site)["slug"]
      sanitized_slug = slug.downcase.gsub(/\s+/, '-')
      File.join(dir, sanitized_slug)
    end
  end
end
