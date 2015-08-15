module JekyllHueman
  module ConfigUtil
    def site_config(site = nil)
      (site || @site || @context && @context.registers[:site]).config
    end

    def simple_hueman_config(site = nil)
      site_config(site)["simple_hueman"] ||= {}
    end
  end
end
