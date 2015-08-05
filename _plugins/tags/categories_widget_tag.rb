module JekyllHueman
  class CategoriesWidgetTag < Liquid::Tag
    def render(context)
      "<div>Categories widget</div>"
    end

    def categories_widget
      <<-MARKUP
<div id="categories-3" class="widget widget_categories"><h3>Categories</h3>
<ul>
  <li class="cat-item cat-item-251"><a href="http://blog.tdg5.com/category/design-patterns-2/">Design Patterns</a> (1)
</li>
  <li class="cat-item cat-item-11"><a href="http://blog.tdg5.com/category/dev/">Dev</a> (9)
<ul class="children">
  <li class="cat-item cat-item-41"><a href="http://blog.tdg5.com/category/dev/bash/">Bash</a> (2)
</li>
  <li class="cat-item cat-item-521"><a href="http://blog.tdg5.com/category/dev/git/">Git</a> (1)
</li>
  <li class="cat-item cat-item-31"><a href="http://blog.tdg5.com/category/dev/linux/">Linux</a> (2)
</li>
  <li class="cat-item cat-item-471"><a href="http://blog.tdg5.com/category/dev/project-announcments/">Project Announcments</a> (1)
</li>
  <li class="cat-item cat-item-141"><a href="http://blog.tdg5.com/category/dev/ruby/">Ruby</a> (7)
  <ul class="children">
  <li class="cat-item cat-item-381"><a href="http://blog.tdg5.com/category/dev/ruby/anti-patterns/">Anti-Patterns</a> (1)
</li>
  <li class="cat-item cat-item-241"><a href="http://blog.tdg5.com/category/dev/ruby/design-patterns/">Design Patterns</a> (1)
</li>
  <li class="cat-item cat-item-211"><a href="http://blog.tdg5.com/category/dev/ruby/ruby-internals/">Internals</a> (3)
</li>
  <li class="cat-item cat-item-311"><a href="http://blog.tdg5.com/category/dev/ruby/journeyman/">Journeyman</a> (1)
</li>
  <li class="cat-item cat-item-581"><a href="http://blog.tdg5.com/category/dev/ruby/tools/">Tools</a> (1)
</li>
  </ul>
</li>
  <li class="cat-item cat-item-21"><a href="http://blog.tdg5.com/category/dev/unix/">Unix</a> (1)
</li>
</ul>
</li>
    </ul>
    </div>
      MARKUP
    end
  end
end

Liquid::Template.register_tag("categories_widget", JekyllHueman::CategoriesWidgetTag)
