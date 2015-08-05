module JekyllHueman
  class LayoutClassTag < Liquid::Tag
    include HelperAccessors

    DEFAULT_KEY = "__default__".freeze
    DEFAULT_LAYOUT_CLASS = "col-3cm".freeze
    LAYOUT_CLASSES = {
      "3-column" => "col-3cm",
      DEFAULT_KEY => DEFAULT_LAYOUT_CLASS,
    }.freeze

    def render(context)
      @context = context
      LAYOUT_CLASSES[page_layout] ||
      LAYOUT_CLASSES[ancestor_layout_class || DEFAULT_KEY]
    end

    private

    def ancestor_layout_class
      ancestor_layout = layouts[page_layout]
      while ancestor_layout
        layout = ancestor_layout.data["layout"]
        return layout if LAYOUT_CLASSES.key?(layout)
        ancestor_layout = layouts[ancestor_layout.data["layout"]]
      end
      nil
    end
  end
end

Liquid::Template.register_tag("layout_class", JekyllHueman::LayoutClassTag)
