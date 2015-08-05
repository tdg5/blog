module JekyllHueman
  module HelperAccessors
    def author_data(author)
      @context.registers[:site].data["authors"][author]
    end

    def layouts
      @context.registers[:site].layouts
    end

    def page_layout
      @context.registers[:page]["layout"]
    end
  end
end
