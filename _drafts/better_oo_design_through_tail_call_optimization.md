---
author: Danny Guinther
categories: [dev/ruby, dev/object-oriented design]
featured_image:
  alt_text: Pry Plugins
  title: Pry Plugins
  url: /assets/images/featured/2015-06-27-crafting-your-first-pry-plugin.jpg
layout: post
tags: [recursion, ruby, tail call, tail call optimization, tail recursion, tail recursive, object-oriented, object-oriented design]
title: Better Object-Oriented Design Through... Tail-Call Optimization?
---

## Or Why Object-Oriented Languages Need Tail Calls Ruby Edition

In preparation for my upcoming [RubyConf][RubyConf] talk, [A Muggle's Guide to
Tail-Call Optimization in Ruby][RubyConf - TCO], I've been continuing to research
[tail-call optimization][Wikipedia - TCO] and how [TCO][Wikipedia - TCO] might
benefit Ruby devs.  Yesterday, I came across an argument which certainly doesn't
make an irrefutable case for TCO in Ruby, but is interesting nonetheless.
Speaking from a functional programming perspective, there's ample argument for
tail-call elimination, however this particular argument comes at TCO from an
object-oriented perspective.

[![Functional][xkcd - Functional Comic]][xkcd - Functional]

The argument, at least in the form I found it, comes from [Guy
Steele][Wikipedia - Guy Steele] in a long lost blog post from 2009. Formerly part
of the Project Fortress Blog, the post is still available from [a mirror over at
eighty-twenty.org][EightyTwenty - Why OO Languages Need Tail Calls].

### Strawman
```ruby
# Abstract UnionList base class
class AbstractUnionList
  private :initialize

  def length
    how_many?(0)
  end

  def how_many?(counter)
    raise NotImplementedError
  end
end

# UnionList NullObject
class NullUnionList < AbstractUnionList
  public :initialize

  def how_many?(counter)
    counter
  end
end

# How one might intuitively implement UnionList
class UnionList < AbstractUnionList
  attr_reader :adjoining

  def initialize(adjoining)
    @adjoining = adjoining
  end

  def how_many?(counter)
    adjoining.how_many?(counter + 1)
  end
end

# OO-design violating work around for SystemStackError
class IterativeUnionList < UnionList
  def how_many?(counter)
    remaining = self
    count = 0
    # Shouldn't have to know anything about NullUnionList :(
    while !remaining.is_a?(NullUnionList)
      count += 1
      remaining = remaining.adjoining
    end
    count
  end
end

# OO-design friendly and it works? Still my beating heart!
require "tco_method"
class TCOUnionList < UnionList
  extend TCOMethod::Mixin
  tco_method :how_many?
end

# A class to test each of the UnionList implementations
class UnionListTest
  def test(class_under_test, length)
    last = NullUnionList.new
    length.times { last = class_under_test.new(last) }
    msg = "class_under_test=#{class_under_test.name} length=#{length} result="
    msg.concat(last.length == length ? "Success" : "Fail")
    puts(msg)
  rescue StandardError, SystemStackError => e
    puts msg.concat("Fail error=#{e.class}")
  end
end

# Let the testing begin!
test_case = UnionListTest.new
classes_to_test = [
  UnionList,
  IterativeUnionList,
  TCOUnionList,
]

divider = "-----------------"
puts divider

# Test lists of length 1..10000
5.times do |pow|
  length = 10 ** pow
  classes_to_test.each do |class_under_test|
    test_case.test(class_under_test, length)
  end
  puts divider
end

# -----------------
# class_under_test=UnionList length=1 result=Success
# class_under_test=IterativeUnionList length=1 result=Success
# class_under_test=TCOUnionList length=1 result=Success
# -----------------
# class_under_test=UnionList length=10 result=Success
# class_under_test=IterativeUnionList length=10 result=Success
# class_under_test=TCOUnionList length=10 result=Success
# -----------------
# class_under_test=UnionList length=100 result=Success
# class_under_test=IterativeUnionList length=100 result=Success
# class_under_test=TCOUnionList length=100 result=Success
# -----------------
# class_under_test=UnionList length=1000 result=Success
# class_under_test=IterativeUnionList length=1000 result=Success
# class_under_test=TCOUnionList length=1000 result=Success
# -----------------
# class_under_test=UnionList length=10000 result=Fail error=SystemStackError
# class_under_test=IterativeUnionList length=10000 result=Success
# class_under_test=TCOUnionList length=10000 result=Success
# -----------------
```
[View Gist][Strawman Gist]

[EightyTwenty - Why OO Languages Need Tail Calls]: http://www.eighty-twenty.org/2011/10/01/oo-tail-calls.html "Why Object-Oriented Languages Need Tail Calls"
[NEU - Functional Objects]: http://www.ccs.neu.edu/home/matthias/Presentations/ecoop2004.pdf "Functional Objects by Matthias Felleisen"
[RubyConf]: http://rubyconf.org/ "RubyConf | 2015"
[RubyConf - TCO]: http://rubyconf.org/program#prop_1447 "RubyConf | 2015 | A Muggle's Guide to Tail Call Optimization in Ruby"
[Strawman Gist]: https://gist.github.com/tdg5/ff140ae34a556a488c50 "Better Object-Oriented Design Through... Tail-Call Optimization?"
[Wikipedia - Guy Steele]: https://en.wikipedia.org/wiki/Guy_L._Steele,_Jr. "Wikipedia.org - Guy L. Steele, Jr."
[Wikipedia - TCO]: https://en.wikipedia.org/wiki/Tail_call "Wikipedia.org - Tail call"
[xkcd - Functional Comic]: https://imgs.xkcd.com/comics/functional.png "Functional programming combines the flexibility and power of abstract mathematics with the intuitive clarity of abstract mathematics."
[xkcd - Functional]: https://xkcd.com/1270/ "Functional programming combines the flexibility and power of abstract mathematics with the intuitive clarity of abstract mathematics."
