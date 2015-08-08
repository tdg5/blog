require_relative "../pages/author_page"

module JekyllHueman
  class AuthorPageGenerator < Jekyll::Generator
    LIST_HASH_PROC = lambda { |h, k| h[k] = [] }

    def generate(site)
      layout = AuthorPage.layout_for_site(site)
      return unless site.layouts.key?(layout)
      author_posts(site).each_pair do |author, posts|
        site.pages << AuthorPage.new(site, author, posts)
      end
    end

    private

    def author_posts(site)
      posts = Hash.new(&LIST_HASH_PROC)
      site.posts.each { |post| posts[post.data["author"]] << post }
      posts
    end
  end
end
