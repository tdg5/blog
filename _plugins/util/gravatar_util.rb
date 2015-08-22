require "digest"

module JekyllHueman
  module GravatarUtil
    GRAVATAR_AVATAR_BASE_URL = "https://www.gravatar.com/avatar/".freeze

    def gravatar_avatar_url(email_or_gravatar_hash, size = nil, default = nil, rating = nil)
      if /@/ === email_or_gravatar_hash
        gravatar_hash = gravatar_hash(email_or_gravatar_hash)
      else
        gravatar_hash = email_or_gravatar_hash
      end
      query_elements = []
      query_elements << "s=#{size}" if size
      query_elements << "d=#{default}" if default
      query_elements << "r=#{rating}" if rating
      uri = URI(File.join(GRAVATAR_AVATAR_BASE_URL, gravatar_hash))
      uri.query = query_elements.join("&") unless query_elements.empty?
      uri.to_s
    end

    private

    def gravatar_hash(email)
      Digest::MD5.hexdigest(email.strip.downcase)
    end
  end
end
