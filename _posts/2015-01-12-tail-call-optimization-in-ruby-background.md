---
author: Danny Guinther
categories: [dev/ruby/internals]
featured_image:
  alt_text: Recursive Guinea Pigs
  title: Recursive Guinea Pigs
  url: /assets/images/featured/2015-01-12-tail-call-optimization-in-ruby-background.jpg
layout: post
tags: [recursion, ruby, ruby vm, tail call, tail call optimization, tail recursion, tail recursive]
title: 'Tail Call Optimization in Ruby: Background'
---
Back in November, care of [/r/ruby](https://www.reddit.com/r/ruby), I came
across [a blog post by Nithin Bekal, Tail Call Optimization in
Ruby](http://nithinbekal.com/posts/ruby-tco/), demonstrating Ruby's built-in
support for tail call optimization and I have to admit, my mind was a little
blown.

It's not that I have a specific need for tail call optimization. In fact,
I can't think of even a single situation where I would have done
things differently if I'd known the VM supported it. But, I guess I was
surprised to find that tail call optimization was just hiding somewhere in the
Ruby VM, waiting to be flipped on with a compile flag, or **at runtime**.

I think it was this ability to just turn it on at any time that blew my mind.
Not just that it was hiding in there somewhere, but that the VM is flexible
enough to swap in the machinery to support tail call optimization whenever you
decide you want it. Pretty awesome.

With no particular use for tail call optimization, I've just been sitting on the
knowledge, the notion bouncing around in my head. That is, until earlier
this week when I decided I would try to apply some of what I learned from reading
[Pat Shaughnessy's Ruby Under a Microscope](http://patshaughnessy.net/ruby-under-a-microscope)
to better understanding how the Ruby VM can be so flexible when it comes to tail
call optimization.

Though I think that that will make for an interesting blog post, it's turned into a
bit of an epic. So this week, I'm going to begin with a little background on
tail call optimization and hopefully build on what others have already shared
with some of what I've learned about Ruby's implementation of tail call
optimization while trudging through Ruby's depths. Then, in my next post, with
the stage already set, we can get into the internals of how the Ruby VM makes
tail call optimization happen at runtime.

Let's get started!

## A little background on tail call optimization
[Nithin's article](http://nithinbekal.com/posts/ruby-tco/) does a great job of
explaining tail recursive functions and tail call optimization, so if you're a
little iffy on either subject, I'd recommend reading that before you continue
with this post. The [Tail call entry in Wikipedia](https://en.wikipedia.org/wiki/Tail_call)
is also a useful resource for even more depth on the subject.

To summarize, tail call optimization, or tail call elimination as it is also
known, is a special feature of some kinds of tail recursive functions that
allows for the tail call to be implemented without adding a new stack frame to
the call stack. This allows for more efficient tail calls while also
allowing the size of the stack to remain constant which in turn allows recursion
to be used in situations that might otherwise encounter a stack overflow without
tail call optimization.

## Ruby and tail call optimization
Starting with Ruby 1.9.2, the Ruby VM offers built-in, though experimental,
support for tail call optimization. That said, there are other ways of achieving
tail call optimization without enabling it in the VM. [Magnus Holm offers a
couple of other hacks for achieving tail call optimization in Ruby in his blog post
Tailin' Ruby](http://timelessrepo.com/tailin-ruby), which is worth the read
just for the innovative ways he attempts to solve the problem, even if you're
fine to use the Ruby VM's implementation of tail call optimization. Maybe it's
just because I haven't had an itch that I needed tail call optimization to
scratch, but using **redo** to emulate tail call optimization in a performant
fashion is pretty damn clever.

Now, although support for tail call optimization is built into the VM, because
of its experimental nature it isn't enabled by default and must be turned on
either with a flag when compiling Ruby or by configuring
**RubyVM::InstructionSequence** at runtime with special compile options. There
was some talk of [enabling tail call optimization by default around the time
that Ruby 2.0 was released](https://bugs.ruby-lang.org/issues/6602), however
this hasn't come to be for a number of reasons: Primary concerns were that tail
call optimization makes it difficult to implement **set_trace_func** and also
causes backtrace weirdness due to the absence of a new stack frame.

Now that we have a little background on tail call optimization in Ruby, let's
take a look at an example of a tail recursive, tail call optimizable function.

## A tail recursive Guinea pig
In order for us to take Ruby's implementation of tail call optimization for a
test drive and to help us get to the bottom of Ruby's implementation of tail
call optimization in my next post, we'll first need a tail recursive function to
be the subject of our experiments. As it turns out, we can actually extract such
a subject from the Ruby source code itself.

Depending on your feelings about the recent debate regarding how Ruby is
tested[^1][^2], it may surprise you to learn that our Guinea pig comes directly
from Ruby's built-in test suite. After all, though tail call optimization may
not be enabled by default, and though it may only be experimental at this time,
it's not unreasonable to think that there'd be a test for it somewhere. That
somewhere is among a handful of other tests for various optimizations to the
Ruby VM in the Ruby source at [test/ruby/test_optimization.rb](https://github.com/ruby/ruby/blob/fcf6fa8781fe236a9761ad5d75fa1b87f1afeea2/test/ruby/test_optimization.rb#L213).

The test that is home to our Guinea pig is somewhat unremarkable, so though
you're welcome to review the full contents of the test, for our purposes I've
extracted the tail recursive factorial function used by the test with some
refactoring to, among other things, isolate the HEREDOC and make it work outside
of the test:

```ruby
  code = <<-CODE
    class Factorial
      def self.fact_helper(n, res)
        n == 1 ? res : fact_helper(n - 1, n * res)
      end

      def self.fact(n)
        fact_helper(n, 1)
      end
    end
  CODE
  options = {
    tailcall_optimization: true,
    trace_instruction: false,
  }
  RubyVM::InstructionSequence.new(code, nil, nil, nil, options).eval
```

The tail recursive method of interest above is the **fact_helper** method. It
should hopefully be pretty obvious that **fact_helper** is tail recursive given
that, in all but the base case, the final action of the method is the invocation
of the itself with primitive values. Other than the tail recursive nature
of this function, there are a couple of other things going on here that are worth
noting.

First, as I alluded to before in regard to tail call optimization not being
enabled by default, currently it is not possible to turn on tail call
optimization without also disabling the **set_trace_func** capabilities of the VM.
This can be seen above in the option to **RubyVM::InstructionSequence** setting
**trace_instruction** to false.

Second, this example demonstrates the best strategy of enabling tail call
optimization that I have come across so far. I say this because the other
examples I've referenced have all enabled tail call optimization by changing
**RubyVM::InstructionSequence.compile_option**, effectively enabling tail call
optimization globally.

Though at least one source suggested that the modified compile options would only be
applied to code directly compiled with **RubyVM::InstructionSequence**, this is
incorrect. In fact, any files loaded after the change to
**RubyVM::InstructionSequence.compile_option** will be compiled with tail call
optimization enabled. This can be verified by running the following contrived
test script that adapts our Guinea pig both to evidence the global nature of
**RubyVM::InstructionSequence.compile_option** and to demonstrate the utility of
tail call optimization.

```ruby
# Flag indicating whether this is the first time time this file has been loaded
$first_load = true if $first_load.nil?

# Declare classes to facilitate #instance_eval later
class FirstLoadFactorial; end
class ReloadedFactorial; end

# On the first load, extend FirstLoadFactorial,
# On the second load, extend ReloadedFactorial.
klass = $first_load ? FirstLoadFactorial : ReloadedFactorial

# Tail recursive factorial adapted from
# https://github.com/ruby/ruby/blob/fcf6fa8781fe236a9761ad5d75fa1b87f1afeea2/test/ruby/test_optimization.rb#L213
klass.instance_eval do
  def self.fact_helper(n, res)
    n == 1 ? res : fact_helper(n - 1, n * res)
  end

  def self.fact(n)
    fact_helper(n, 1)
  end
end

# Turn on tailcall optimization
RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false,
}

# This check avoids calculating the factorial twice; ReloadedFactorial will only
# respond to :fact after the file has been reloaded.
if ReloadedFactorial.respond_to?(:fact)
  begin
    puts "FirstLoadFactorial: #{FirstLoadFactorial.fact(50000).to_s.length}"
  rescue SystemStackError
    puts 'FirstLoadFactorial: stack level too deep'
  end

  # 50000! is 213,237 digits long, so display just the length of the calculation
  puts "ReloadedFactorial: #{ReloadedFactorial.fact(50000).to_s.length}"
end

# Reload the file on the first load only
if $first_load
  $first_load = false
  load __FILE__
end

# $ ruby tail_optimized_reload.rb
#   FirstLoadFactorial: stack level too deep
#   ReloadedFactorial: 213237
```

[View on GitHub](https://github.com/tdg5/blog_snippets/blob/8cdc800e711f5270754e352b9f3458d7e429b87d/lib/blog_snippets/tail_call_optimization_in_ruby_internals/tail_optimized_reload.rb)

Since tail call optimization is still an experimental feature, if you're going
to use tail call optimization in production code or in code that could become
production code, the strategy demonstrated by the Ruby core test of creating a
new **RubyVM::InstructionSequence** object that can be used to load/compile tail
call optimized code without affecting other code compiled by the VM later is
absolutely the right way to go.

## End Part I
That does it for our initial foray into tail call optimization in Ruby. I hope
you've found something here today worth the price of admission. Stay tuned for
my next post in which we'll take our tail recursive Guinea pig for a deep dive into the
internals of Ruby, all the way from the Ruby source, through the YARV instructions
just below the surface, down deep into the C weeds in search of the source
of Ruby's tail call optimization implementation. It'll certainly be an
interesting ride.

[^1]: http://rubini.us/2014/12/31/matz-s-ruby-developers-don-t-use-rubyspec/
[^2]: https://gist.github.com/nateberkopec/11dbcf0ee7f2c08450ea
