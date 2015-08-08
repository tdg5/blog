---
author: Danny Guinther
categories: [dev/project announcements, dev/ruby]
featured_image:
  alt_text: tco_method
  title: tco_method
  url: /assets/images/featured/2015-03-15-introducing-the-tco-method-gem.jpg
layout: post
permalink: /introducing-the-tco-method-gem
tags: [gem, project announcements, recursion, ruby, tail call, tail call optimization, tail recursion, tail recursive, tco_method]
title: Introducing the tco_method gem
---
Earlier this week I published a gem intended to help simplify the process of
compiling Ruby code with tail call optimization enabled in MRI Ruby. The gem,
[tco_method](https://rubygems.org/gems/tco_method), builds on my recent research
into the [internals of Ruby's implementation of tail call optimization](http://blog.tdg5.com/tail-call-optimization-ruby-deep-dive/)
and the ideas presented in [Nithin Bekal's article *Tail Optimization in Ruby*](http://nithinbekal.com/posts/ruby-tco/).

The gem aims to ease the process of compiling select Ruby code with tail call
optimization by providing a helper method, [**TCOMethod.tco_eval**](http://www.rubydoc.info/gems/tco_method/TCOMethod/Mixin:tco_eval),
for evaluating code with tail call optimization enabled and a mix-in,
[**TCOMethod::Mixin**](http://www.rubydoc.info/gems/tco_method/TCOMethod/Mixin),
for adding annotations to Classes and/or Modules for annotating singleton or
instance methods that should be compiled with tail call optimization enabled.
You can see what each of these approaches would look like below.

## TCOMethod.eval

```ruby
TCOMethod.tco_eval(<<-CODE)
  module MyFactorial
    def self.factorial(n, acc = 1)
      n <= 1 ? acc : factorial(n - 1, n * acc)
    end
  end
CODE

MyFactorial.factorial(10_000).to_s.length
# => 35660
```

Though not as powerful as Ruby's native **eval** method, **TCOMethod.tco_eval** provides
easy access to the full power of Ruby with the added benefit of tail call
optimization. The major downside to using **tco_eval** is that code must be
provided as a String. Also, unlike Ruby's standard **eval** method, **tco_eval**
currently cannot take a binding for the evaluation which can make it awkward
at times to connect code that's being compiled with tail optimization to
other application code compiled by Ruby's primary compilation process.

All that said, I view **tco_eval** as more of a starting point than a solution.
It inches the door a little wider for the Ruby community to play with tail call
optimization and get a better sense of how and when it might be useful. I think
this is an exciting opportunity that Nithin Bekal's work with TCO method
decorators began to explore and, as we'll see momentarily, the
**TCOMethod::Mixin** continues to test the waters of.

Beyond the opportunity it offers the Ruby community, I'm also excited because
the [tco_method gem](https://rubygems.org/gems/tco_method) seems like a great
opportunity to dig into Ruby's C extensions and see how extending the gem to
interface with Ruby's C code more directly could extend the abilities of the gem
while further simplifying access to tail call optimization in Ruby.

## TCOMethod::Mixin#tco_method

```ruby
class MyFibonacci
  extend TCOMethod::Mixin

  def fibonacci(index, back_one = 1, back_two = 0)
    index < 1 ? back_two : fibonacci(index - 1, back_one + back_two, back_one)
  end
  tco_method :fibonacci
end

puts MyFibonacci.new.fibonacci(10_000).to_s.length
# => 2090
```

The **TCOMethod::Mixin** module provides annotations at the Class and Module
level allowing a developer access to some of the niceties of tail call
optimization, but without the awkwardness that comes from String literal code or
heredocs. In the style of some of Ruby's other class annotations like
**private_class_method** or **module_function**, the **tco_module_method**,
**tco_class_method**, and eponymous *tco_method** annotation for instance
methods, allow a user to annotate a previously defined method indicating that
the specified method should be recompiled with tail call optimization enabled.

Currently these helper methods are little more than nicely wrapped hacks that
use some trickery to redefine the specified method with tail call optimization
enabled. More specifically, the helper annotations will:

- find the method identified by the given argument
- retrieve the source for that method using the [method_source
  gem](https://github.com/banister/method_source)
- generate a redefinition expression from the method source that
  reopens the defining Module or Class and redefines the method
- pass the generated redefinition expression to **TCOMethod.tco_eval**,
  effectively overriding the previously defined method with the new tail call
  optimized version

While this works in most situations, there are quite a few [pitfalls and
gotchas](https://github.com/tdg5/tco_method/tree/6241e57f8bb8478e2ef2286d4cc6e463c0198e61#gotchas)
that come from this approach.

For one, this approach only works for methods defined using the **def** keyword.
Though in some cases methods defined using **define_method** could be redefined
correctly, given that **define_method** takes a block that maintains a closure
with the definition context, there's no foolproof way to ensure that all methods
defined using **define_method** could be reevaluated with tail call optimization
enabled because of references to the closure context.

Another gotcha worth mentioning is that because the current implementation
relies on reopening the parent Module or Class, the helper methods won't work on
anonymous Classes or Modules because they cannot be reopened by name. With more
hacking there are ways to get around this limitation, but, at present, I don't
think more hacking is the path forward and something more along the lines of a C
extension is the right way to address these issues.

## Interesting problems

As I said before, I think the [tco_method gem](https://rubygems.org/gems/tco_method)
is a starting point, not a solution, and I'm excited by the various
opportunities and challenges it presents. Though I am definitely interested in
learning more about Ruby's C extension support, the [tco_method gem](https://rubygems.org/gems/tco_method)
has already presented some interesting problems despite its current primitive
and hacky nature.

For example, in order to test that a recursive factorial method would no longer
encounter a stack overflow after being recompiled with tail call optimization
enabled, I first had to devise a means of ensuring that that method would
have encountered a stack overflow without tail call optimization enabled and at
what point that stack overflow would have occurred. To achieve this, I wrote a
test helper that performs [a binary search to discover how many stack frames a
recursive function can allocate before a stack overflow is
encountered](https://github.com/tdg5/tco_method/blob/c28895742e18e9d87393c97435db99e4b71c5fa3/test/test_helpers/stack_busters/factorial_stack_buster.rb#L25).

Though my current solution could use some refactoring, I thought this was a fun
and interesting problem to solve. Though I don't find binary search particularly
interesting on its own, I found this particular case interesting because the
expensive nature of the **raise**/**rescue** cycle in Ruby introduces a sort of
penalty to the process such that the process will be much quicker if the point
of overflow can be discovered while causing as few **SystemStackError**
exceptions as possible. I think this detail makes the binary search more
interesting because there's more to it than just finding the desired result in as few
operations as possible, there are also other considerations to keep in mind that
could totally change how the utility of the search is assessed. In fact, given
this behavior, a binary search may not be the best approach at all.

For now, I've taken the approach of using one binary search to find a point of
overflow, then using a second binary search to find the exact point at which the
recursive function begins to exceed the system stack between the last successful
invocation and the overflowing invocation.

I haven't tried to do much research on this particular type of problem yet, but
I'm excited to revisit this search function at some point in the future and see
what other ideas are out there for me to throw at the problem.

**Update:** After discussing the peculiarities of this approach with my coworker
Matt Bittarelli, he suggested a couple of alternatives to the binary search
approach that seemed intriguing and simpler. The first idea was simply to [force
a **SystemStackError** and check the length of the exception's backtrace from the
**rescue** context to determine the maximum stack
depth](https://github.com/tdg5/tco_method/commit/e2e7f30314fd3d0e1b2d138328d7deeb31e7bd96).
Though this approach works in Ruby 2.2, [it does not work in Ruby 2.0 or Ruby
2.1](https://travis-ci.org/tdg5/tco_method/builds/54811953). The other idea Matt
had was that maybe a **SystemStackError** wasn't necessary at all if a block
could be used to monitor how the stack depth changed from iteration to
iteration. Though a little mind bending, I was able to [use a recursive method
that yields to a block to monitor how the stack depth changes and using that
information determine whether the method had been compiled with tail call
optimization enabled](https://github.com/tdg5/tco_method/commit/c2963276376f7705b2fb1b6b582d88f07954c02f).
Though the means of determining if a method is compiled with tail call
optimization has changed since I initially wrote this article, I think all three
of the above approaches are interesting and I expect more interesting problems
will emerge as work on this gem continues. Thanks again to Matt Bittarelli for
his insights into the problem!

## Test drive

Because tail recursive functions can typically be restated in other ways that
don't require tail call optimization, I'm still on the fence as to whether TCO
provides any real value other than expanding the expressiveness of the Ruby
language. As such, I encourage you to take the [tco_method gem](https://rubygems.org/gems/tco_method)
for a test drive and explore the opportunities it presents. If you do take
it for a test drive, drop me a line to let me know how it went. I'd be
interested to hear about your experiences both with tail call optimization in
Ruby-land and with the API offered by the [tco_method gem](https://rubygems.org/gems/tco_method).
Contributions are also always welcome!

[View the tco_method gem on RubyGems](https://rubygems.org/gems/tco_method)  
[View the tco_method gem on GitHub](https://github.com/tdg5/tco_method)

As always, thanks for reading!
