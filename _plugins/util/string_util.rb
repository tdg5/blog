module JekyllHueman
  module StringUtil
    def titleize(str)
      str.gsub(/(?:^|[ -])[a-z]/, &:upcase)
    end
  end
end
