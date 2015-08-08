module JekyllHueman
  module ConfigUtil
    def simple_hueman_config(site = nil)
      (site || @site || @context && @context.registers[:site]).config["simple_hueman"] || {}
    end
  end
end
