---
author: Danny Guinther
categories: [dev/ruby/anti-patterns/, dev/ruby/internals]
featured_image:
  alt_text: I'm going to continue never washing this cheek again
  title: I'm going to continue never washing this cheek again
  url: /assets/images/featured/2015-02-28-eager-boolean-operators-a-pattern-to-continue-never-using.jpg
layout: post
tags: [anti-pattern, anti-patterns, eager boolean operators, eager evaluation, logical operator, logical operators, ruby internals]
title: 'Eager Boolean Operators: A Pattern to Continue Never Using'
---
In relaying the story of eager Boolean operators, it is best to begin with their
more ubiquitous siblings, short-circuiting logical Boolean operators. This is
perhaps best achieved with an example:

```ruby
true || Seriously(this(is(valid(Ruby!))))
# => true

false && 0/0
# => false
```

In Ruby, and many other common programming languages,[^1] the Boolean operators
used for chaining together logical expressions are designed to minimize the
amount of work required to determine the outcome of a logical expression. More
specifically, when determining the outcome of a logical expression as few of
the statements in the expression will be evaluated as possible. In the previous
example, this notion, known as [short-circuit evaluation](https://en.wikipedia.org/wiki/Short-circuit_evaluation),
is exploited to include some very bad code in a manner that renders that bad
code completely innocuous.

In the first example, the short-circuiting behavior of the **||** Boolean
operator, representing a [logical **OR** or logical disjunction](https://en.wikipedia.org/wiki/Logical_disjunction)
operation, prevents a series of undefined methods from causing a fatal
**NoMethodError** exception. This code can safely be executed because when the
first argument of an **OR** operation is **true** then the overall value of the
expression must also be **true**. Put more simply, **true OR _anything_** will
always result in **true**. Given this logical maxim, at runtime the program does
not need to execute the right-hand side of the expression and can move on
without executing the explosive code.

Similarly, in the second example, the short-circuiting behavior of the **&&**
Boolean operator, representing a [logical **AND** or logical conjunction](https://en.wikipedia.org/wiki/Logical_conjunction)
operation, prevents a fatal **ZeroDivisionError** exception. This code can
safely be executed because when the first argument of an **AND** operation is
**false** then the overall value of the expression must also be **false**. In
simpler terms, **false AND _anything_** will always result in **false**. Given
this basic tenant of Boolean logic, at runtime the program can decide the
outcome of the logical expression without executing the subversive right-hand
side of the expression.

It's interesting to note that, because of their short-circuiting behavior, the
**||** and **&&** Boolean operators are more than just logical operators,
they actually also function as control structures. To demonstrate this,
though the previous example used Boolean operators, it could just have easily
have been written with more traditional flow control structures like **if** or
**unless**:

```ruby
# The true result is lost, but we weren't storing it anyway, so no problemo.
Seriously(this(is(valid(Ruby!)))) unless true
# => nil

# Again, the result of false is lost, but for this example that's okay.
0/0 if false
# => nil
```

Eager Boolean operators come into play when someone inevitably asks the
question, "what if we don't want to short-circuit?"

## Eager Boolean Operators

As their name suggests, eager Boolean operators are logical operators that do
not short-circuit. Instead, even when the outcome of a logical expression is
determined, they continue to execute the logical expression until it has been
fully evaluated. If we changed our example of short-circuiting Boolean operators
to use eager Boolean operators instead, we'd no longer be safe from that
sinister code. Here it is again as such with a couple of other tweaks:

```ruby
begin
  true | Seriously(this(is(valid(Ruby!))))
rescue NoMethodError => e
  e.class
end
# => NoMethodError

begin
  false & 0/0
rescue ZeroDivisionError => e
  e.class
end
# => ZeroDivisionError
```

In the first example above, I've modified the earlier example to replace the
**||** Boolean operator with an alternative Boolean operator included in Ruby
that offers eager evaluation of logical **OR** expressions, **|**. Though more
commonly used for bitwise operations, when used with **true**, **false**, or
**nil**, the **|** operator functions similarly to its counterpart, **||**,
except without the short-circuiting behavior. Evidence of this eager evaluation
behavior can be seen above in that the outcome of the **begin** block is not
true, as would be the case if **|** were a short circuiting operator, but it is
instead the exception class we would expect to be raised if the right-hand side
of the logical expression had been evaluated.

Similarly, in the second example above, I've modified the earlier example and
replaced the **&&** Boolean operator with Ruby's eager Boolean **AND**
operator, **&**. Also more commonly used in bitwise expressions, when used with
**true**, **false**, or **nil**, the **&** operator behaves similarly to its
short-circuiting cousin, **&&**, except that it eagerly evaluates the right-hand
side of the logical expression even if the overall outcome of the expression has
already been determined. Once again, this behavior can be seen in that the
result of the **begin** block is the **ZeroDivisionError** class, which would
only be the case if the right-hand side of the logical expression had been
evaluated.

Though this example helps demonstrate the eager evaluation properties of the
**|** and **&** Boolean operators, given its explosive nature, it doesn't offer
much insight into how eager Boolean operators might be useful. Having addressed
the question of "what if we don't want to short-circuit?", let us consider
another question that may actually be a better answer to the question than the
one I've just outlined: "why wouldn't you want to short-circuit?"

## Bitwise digression

Before we look at a handful of examples of eager Boolean operators, I'd like to
digress for a moment for a brief discussion of bitwise Boolean operators.
Bitwise Boolean operators are operators like **&** and **|** that perform
operations on Boolean values as though those Boolean values were bits or binary
0s and 1s, where **false** and **nil** are both 0 and **true** is 1. For
example, consider the following truth table for the **&** bitwise operation that
demonstrates the equivalence of the two operations.

| Truth of & | nil   ( 0 ) | false ( 0 ) | true  ( 1 ) |
|------------|-------------|-------------|-------------|
|nil   ( 0 ) | false ( 0 ) | false ( 0 ) | false ( 0 ) |
|false ( 0 ) | false ( 0 ) | false ( 0 ) | false ( 0 ) |
|true  ( 1 ) | false ( 0 ) | false ( 0 ) | true  ( 1 ) |

One behavior of bitwise Boolean operators worth noting is that they always
return a Boolean value. Even if the second argument to a bitwise Boolean
operator is truthy or falsy, or even if the first argument to the bitwise
Boolean operator is falsy, as is the case with **nil**, the result of the
expression will still be a Boolean value. This is in contrast to their logical
Boolean counterparts who are more than content to return a truthy or falsy value
in place of a strict Boolean value.

This behavior can be useful at times, but can certainly come as a surprise to
those who are more familiar with the more ubiquitous logical Boolean operators
and their penchant for returning truthy and falsy values.  The behavior of
bitwise Boolean operators can also surprise the unaware in that unlike the
logical Boolean operators which can be invoked with any two values, the bitwise
Boolean operators must be invoked with either **true**, **false**, or **nil** on
the left-hand side of the expression, otherwise, an error or other unexpected
behavior will occur.

In terms of eager Boolean operators, the bitwise Boolean operators are important
because the eager Boolean operators are a sort of subset of the bitwise Boolean
operators. The **&** and **|** operators are both bitwise Boolean operators, but
in the cases of **true | _anything_** and **false & _anything_** they are also
eager Boolean operators. If this is unclear, the following examples may help.

## Eager Boolean Operators in Practice

Let's look at a couple of examples of eager Boolean operators in practice. After
we've considered a couple of examples, perhaps we'll be better prepared to take
a step back and get more clarity on what aspects or behaviors of eager
evaluation are exploited by these examples in the name of utility. I've done
what I can to try to find examples of eager Boolean operators out in the wild,
but I've not had enormous success. To that end, I've tried to evaluate and order
the examples below in terms of utility. Some examples are mine, some come from
more popular libraries.

### Enumerable#eager_all?

The first example is far and away the best use-case I've found for both bitwise
and eager Boolean operators that I've come across. The example below uses the
bitwise **AND** operator, **&**, to create a version of
[**Enumerable#all?**](http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-all-3F)
that is guaranteed to evaluate all elements in a collection. This is different
from the normal behavior of **Enumerable#all?** in that **Enumerable#all?**
normally discontinues evaluation of the collection as soon as any element in the
collection returns **false** for the provided block.

```ruby
module Enumerable
  def eager_all?
    inject(true) do |result, item|
      result & (block_given? ? yield(item) : item)
    end
  end
end
```

This example leverages the **&** operator to ensure that the right-hand side of
the logical expression is always evaluated. This behavior is combined with
[**Enumerable#inject**](http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-inject)
to ensure that all elements of the collection are evaluated, ultimately
accumulating to the correct result.

The astute among you may have noticed that this example could alternatively have
used the short-circuiting **&&** Boolean operator by flipping the operands like
so:

```ruby
module Enumerable
  def alternative_eager_all?
    inject(true) do |result, item|
      (block_given? ? yield(item) : item) && result
    end
  end
end
```

Though this is true, at runtime this alternative approach draws attention to the
bitwise nature of the **&** operator as compared to its short-circuiting cousin,
**&&**, a difference in nature which I think in this case gives the eager
Boolean operator the edge. The bitwise nature I refer to is, as I mentioned
before and as is demonstrated below, eager Boolean operators will always return
**true** or **false** while the short-circuiting Boolean operators could return
any object depending on the operator and the arguments given to it.  We don't
have to worry about *any* object in the alternative example since the result of
the yield combined with **true** or **false** using **&&**, but we do have
to worry about one other object, **nil**. Because of the short-circuiting nature
of **&&**, if the result of the **yield** is **nil**, the result of the call to
**alternative_eager_all?** will also result in **nil** as demonstrated below:

```ruby
[false, nil].eager_all?
# => false

[false, nil].alternative_eager_all?
# => nil
```

Given that **nil** is also falsy, this isn't really a problem, but I think it
does make **alternative_eager_all?** less robust than it could be.

Another way the **nil** case could be handled without resorting to using an
eager Boolean operator is by double negating the result of the **inject** call
to ensure that a Boolean is returned. That would look like this:

```ruby
module Enumerable
  def alternative_eager_all?
    !!inject(true) do |result, item|
      (block_given? ? yield(item) : item) && result
    end
  end
end
```

Though the practice of double negation is pretty common, as it turns out, the
coercive nature of the bitwise Boolean operators is actually slightly faster
than the more idiomatic double negation. Consider this benchmark generated using
the [benchmark-ips gem](https://github.com/evanphx/benchmark-ips):

```ruby
require "benchmark/ips"

Benchmark.ips do |bm|
  bm.config(:time => 20, :warmup => 5)

  bm.report("Double negate") { !!(true && :a) }
  bm.report("Logical bit-wise coerce") { true & :a }
end

# Calculating --------------------------------------------
#   Double negate                         138.008k i/100ms
#   Logical bit-wise coerce               139.350k i/100ms
# --------------------------------------------------------
#   Double negate            7.262M (± 1.0%) i/s - 36.434M
#   Logical bit-wise coerce  7.825M (± 1.3%) i/s - 39.157M
# --------------------------------------------------------
```

The difference in performance between the two approaches is pretty negligible
and certainly isn't substantial enough to merit choosing bitwise Boolean
coercion over double negation. Keep in mind also that the bitwise coercion (if
you want to call it that) to **true** or **false** is not without its downside.
As I mentioned before, the coercive behavior of eager Boolean operators may
come as a surprise for developers who are more familiar with the behavior of the
more common short-circuiting logical Boolean operators.

### Bringing *before_suite* type behavior to Minitest

The next example is a bit of questionable code of mine from a few years ago. In
this example, I use the **&** eager Boolean operator in an attempt to emulate
behavior similar to **RSpec's #before_suite** hook in a **Minitest** test case
seeing as **Minitest** does not offer a similar behavior.

```ruby
class SomeTest < Minitest::TestCase
  setup { self.class.one_time_setup }

  def self.one_time_setup
    return if @setup_complete & @setup_complete ||= true
    # Some expensive or non-idempotent setup
  end

  def test_something
    # ...
  end
end
```

At the time, I thought this was clever, probably because of its condensed
nature, but a few years later and I can see that this code is excessively tricky
and has obvious, though minor, inefficiencies. This example exploits two tricks
to create a sort of switch that doesn't fire the first time it's evaluated, but
will fire on all subsequent evaluations.

The first trick in this example takes advantage of the fact that accessing a
nonexistent instance variable will never result in an error. The second trick
takes advantage of the **&** operator to ensure that even when the
**@setup_complete** instance variable is **nil**, a second statement is
evaluated that will set **@setup_complete** to true, while still returning
**nil** to the **if** statement. These two tricks allow for the described
behavior as more concisely demonstrated below:

```ruby
def first_time_only
  return if @not_first_time & @not_first_time ||= true
  "Hello world!"
end

first_time_only
# => "Hello world!"

first_time_only
# => nil
```

 The inefficiency of this approach that I referenced earlier is that the
 **@not_first_time** variable is going to be evaluated twice every time the
 **first_time_only** method is invoked, once on both the left and right hand
 sides of the **&** operator. Since this evaluation is cheap, it's not the end
 of the world, but it starts to beg a question that has been nagging me as I've
 become more familiar with bitwise and eager Boolean operators: When is chaining
 logical expressions using eager Boolean operators a better choice than just
 splitting the expression into two statements?

In terms of the **first_time_only** example above, the method could be rewritten
like so by splitting the logical expression into two parts instead of relying on
the tricky behavior of the **&** operator:

```ruby
def first_time_only
  return if @not_first_time
  @not_first_time = true
  "Hello world!"
end
```

## Examples from the real world

I've led with two of my own examples not because of my acute egomania, but
because frankly, I couldn't find many examples of bitwise Boolean operators,
much less eager Boolean operators out there in the wild. Maybe there was a flaw
in the regular expression I used to grep through the wealth of gems I've
accumulated or maybe I've missed some genius examples in the noise of numerical
bitwise expressions and Array intersections, I don't know.

In the end, I was only able to find 4 examples, and unfortunately, three of
those four were similar enough (two were exactly the same!) to make it really
only worth mentioning one. Making matters worse, I'm not convinced any of the
examples are using eager or bitwise Boolean operators in an effective way. But
again, maybe I'm missing something. You be the judge.

### RubySpec: Three flavors of tainted?

The three very similar examples I mentioned above come from the now defunct
[RubySpec](https://github.com/rubyspec/rubyspec) project. Each occurs while
testing whether a **String** has become tainted following a slice operation
[[1]](https://github.com/rubyspec/rubyspec/blob/38b775a32293ce7ec5bdadaa7e70422fb5dc3a68/core/string/slice_spec.rb#L436)
[[2]](https://github.com/rubyspec/rubyspec/blob/38b775a32293ce7ec5bdadaa7e70422fb5dc3a68/core/string/shared/slice.rb#L419)
or a [concatenation using the **+** operator](https://github.com/rubyspec/rubyspec/blob/324c37bb67ea51f197954a37a2c71878eeadea01/core/string/plus_spec.rb#L41).
The example testing concatenation with **+** is the shortest of the bunch, so
let's have a look.

```ruby
it "taints the result when self or other is tainted" do
  strs = ["", "OK", StringSpecs::MyString.new(""), StringSpecs::MyString.new("OK")]
  strs += strs.map { |s| s.dup.taint }

  strs.each do |str|
    strs.each do |other|
      (str + other).tainted?.should == (str.tainted? | other.tainted?)
    end
  end
end
```

In this example, a few instances of the **String** class and their tainted alter
egos are created and then each of the instances is concatenated with each of the
other instances using the **+** operator. For each concatenation produced, the
result is tested to ensure that it is considered tainted if either of its
parents were tainted. During the test to determine if a result **String** should
be tainted or not, we find our bitwise Boolean friend, the **|** operator. But
what advantage does the **|** operator offer in this situation over its
short-circuiting counterpart, **||**?

When **str.tainted?** is **true**, the result of parenthetical expression will
be **true**, however, keep in mind that **other.tainted?** will still be
evaluated, though the result will be discarded. Unless there is some hidden side
effect of calling **other.tainted?** at this point in the test, this seems like
extraneous work to me. If there is a side effect to calling **other.tainted?**
at this point in the test, that's a whole other problem because it seems quite
possible that whatever that side effect is, it could have impacted the outcome
of **(str + other).tainted?**, in which case, who knows what's really being
tested. All this taken into account, I'm inclined to believe that
short-circuiting would be desirable alternative in this case.

Conversely, when **str.tainted?** is **false**, the result of the parenthetical
expression depends entirely on the outcome of **other.tainted?**. This may seem
good in that when **other.tainted?** is **true**, the parenthetical expression
will be **true** and when **other.tainted?** is **false**, the parenthetical
expression will be **false**. However, as we discussed earlier, the eager
Boolean operators only return **true** or **false** unlike their
short-circuiting counterparts. This means that **other.tainted?** could return
**:wtf?** or **nil** and the parenthetical expression would evaluate to **true**
or **false**, respectively. Perhaps this coercion to **true** or **false** was
the goal in choosing **|** over **||**, but in a test, particularly a test aimed
at describing how the language itself should work, this seems like a bad idea to
me.

Overall, it seems like **||** would be a much better choice here than **|**, as
it ensures the minimal amount of evaluation is performed while also ensuring
that the output values of both **str.tainted?** and **other.tainted?** are
tested for validity.

### Ruby: k-nucleotide benchmark

The final example we'll look at is a Ruby implementation of the
[k-nucleotide benchmark](http://benchmarksgame.alioth.debian.org/u32/performance.php?test=knucleotide#about).
Unchanged since it was added to the Ruby source tree in 2007,
[bm_so_k_nucelotide.rb](https://github.com/ruby/ruby/blob/75feee0968c9345e7ffd2bda9835fcd60b4c0880/benchmark/bm_so_k_nucleotide.rb#L40)
utilizes the eager Boolean operator **&** to read lines from a file until a line
is encountered that starts with ">".

```ruby
while (line !~ /^>/) & line do
  seq << line.chomp
  line = input.gets
end
```

The purpose of this code is fairly straightforward, however what is less clear,
is the utility of taking the eager logical conjunction (**&**) of **(line !~ /^>/)**
and **line**.

When the result of the **!~** operation results in **false**, the right-hand
side of the expression will be evaluated and the result discarded. It's
important to keep in mind that this will only happen once because the result of
**false** will end the loop, but more generally speaking, in circumstances
similar to this there's no reason to waste CPU time extraneously evaluating the
right-hand side of the expression. We can be pretty confidant that this
operation is wasteful because the value of **line** has no impact on the outcome
of the logical expression and since we know that **line** is a reference to an
object and not a method call, we know that the evaluation of **line** should not
cause any side effects that might be worth preserving. Again though, since the
eager evaluation is only going to happen once for this loop, it's really not of
great concern.

The case when the **!~** expression evaluates to **true** is a little trickier.
One would think that when the left-hand side of the expression evaluates to
**true**, there would be no point in evaluating **line** as we might expect that
the value of **line** is a **String** that will be coerced into **true** by
**&**. However, the **!~** operator is defined for more than just instances of
**String**. In fact, **true**, **false**, **nil**, and anything that inherits
from **Object** all implement the complement method to **!~**, **=~**, and by
default they all return a value of **nil** for **=~**. This means that in most
cases the **!~** operator will be negating **nil** which means the left-hand
side is going to evaluate to **true** in a lot of cases we might not expect.

In reality though, I suspect that the real reason the right-hand side of the
expression is included is as a guard against **line** having a value of **nil**.
If this is the case, then the only reason to choose **&** over **&&** would be
the ability of **&** to coerce truthy values to **true**. If the result of the
expression were being stored, this might make sense, however, since the result
of the expression is being used as the condition for a **while** loop, it seems
unlikely that this coercion would yield any perceivable benefit. As such, I
think **&&** would be a better choice here because it is more familiar to most
programmers and it will still guard against **nil** values.

In the event that a value of **true** is easier for **while** statement to
consume than other truthy values, we can always flip the condition around like
so:

```ruby
while line && (line !~ /^>/) do
  # ...
end
```

This arrangement has the added benefit of removing the need for the parentheses
and short-circuiting the **!~** operation in situations where **line** is falsy.

But why stop there? Why explicitly guard against **nil** and **false** at all?
Especially when every other **Object** out in the Ruby universe is going to slip
right past this check, resulting in a **NoMethodError** when the program
attempts to call **chomp** on an object that doesn't support **chomp**. When it
comes down to it, the condition of this **while** loop is pretty inadequate.

A lot of the problem with the condition comes from the negation of the **=~**
operation, what if we could avoid that? Given the regular expression of
**/^>/**, it would seem that we're on the lookout for any line that starts with
">". But, what if, instead, we changed the condition such that it were **true**
as long as a line started with anything other than ">"? This can be achieved by
modifying the regular expression and would change the **while** loop to look
like so:

```ruby
while line =~ /^[^>]/ do
  # ...
end
```

Though the regular expression is more complex, I think the whole expression is
much easier to reason about without the negation, extra logical expression, and
parentheses.

I've gotten a little off topic here, so we should move on, but before we do so,
here are a few benchmarks generated using the [benchmark-ips gem](https://github.com/evanphx/benchmark-ips)
for the **&**, **&&**, and altered **Regexp** versions of the **while**
loop when run in the actual context of the nucleotide benchmark:

```ruby
# Calculating ----------------------------------------------
#                    &                        2.000  i/100ms
#                   &&                        2.000  i/100ms
#     Alternate Regexp                        3.000  i/100ms
# ----------------------------------------------------------
#                    &     27.538  (± 3.6%) i/s -    550.000
#                   &&     28.092  (± 3.6%) i/s -    562.000
#     Alternate Regexp     29.000  (± 3.4%) i/s -    582.000
# ----------------------------------------------------------
```

Very minor performance differences, but another case where bitwise Boolean
operators don't seem to be the best choice for the job.

## Optimization by branch avoidance

Having been through a few examples of eager Boolean operators in Ruby, I imagine
you're opinions on the matter are starting to coalesce, I know mine certainly
are. Though I started this article to get a better understanding of when and
why one might want to use eager Boolean operators, the more research I've done,
the more the question for me has become "Why would I ever want to use bitwise or
eager Boolean operators?"

If you looked at the [list of programming languages that support both short-circuiting and eager Boolean operators](https://en.wikipedia.org/wiki/Short-circuit_evaluation#Support_in_common_programming_languages)
I referenced earlier, you may have noticed that quite a few languages support
both types of operators. This seems like a clue that there is a strong
reason to have both types of operators. However, perhaps my Google-fu failed me,
but I really couldn't find a strong argument for using eager Boolean operators.

The best argument I came across that we haven't already discussed in some form
comes from [a Stack Overflow question asking about the difference between the
**||** operator and the **|** operator](https://stackoverflow.com/questions/7101992/why-do-we-usually-use-not-what-is-the-difference/7105382#7105382).
All the way down 8 or 9 answers in is [an answer from Peter Lawrey](http://stackoverflow.com/a/7105382/1169710)
that I think has some merit. Peter writes:

> Maybe use [eager Boolean operators] when you have very simple boolean
> expressions and the cost of short cutting (i.e. a branch) is greater than the
> time you save by not evaluating the later expressions.

I was certainly intrigued by this idea, especially since one of the commenters
on Peter's answer claimed to have actually come across this behavior on some
CPUs.

I could see this type of behavior pretty easily existing in a lower level
language like C, but I had reservations about whether or not something that must
be a pretty minor micro-optimization could bubble all the way up into a higher
level language like Ruby. To find out, I put together the following benchmark,
again making use of the [benchmark-ips gem](https://github.com/evanphx/benchmark-ips):

```ruby
require "benchmark/ips"

Benchmark.ips do |bm|
  bm.config(:time => 20, :warmup => 5)

  bm.report(";") { true ; true }
  bm.report("&&") { true && true }
  bm.report("&") { true & true }
end
```

The goal of this benchmark is to use the simplest case possible to get an idea
of the cost of branching compared to a more strict eager evaluation alternative.
To this end, both the **&&** and **&** operators are benchmarked. In addition,
to provide a baseline, the benchmarks also include a version that simply
evaluates **true** twice to ensure a benchmark that includes no branching or
other silly business. I found the results surprising:

```ruby
# Calculating -------------------------
#    ;                 131.478k i/100ms
#   &&                 128.222k i/100ms
#    &                 126.305k i/100ms
# -------------------------------------
#    ;   9.346M (± 3.4%) i/s - 186.699M
#   &&   8.867M (± 3.2%) i/s - 177.075M
#    &   7.812M (± 2.6%) i/s - 156.113M
# -------------------------------------
```

I wasn't surprised to find that **&** wasn't faster than **&&**, but what did
surprise me was how much slower **&** actually was compared to **&&**,
especially in a case where I expected there to be a fairly negligible
difference. It's pretty clear from this benchmark that, at least in Ruby, any
branching that's avoided by using the **&** operator is insignificant in
comparison to other overhead. But what could that other overhead be? Though it
may surprise you, that overhead is a method call. *Say what?*

## Holy method calls, Batman!

As it turns out, in the case of Boolean values, bitwise operators like **&** and
**|** aren't so much operators as they are methods on **TrueClass**,
**FalseClass**, and **NilClass**! Consider for example the C source of the
bitwise **|** method on **TrueClass**:

```c
static VALUE
true_or(VALUE obj, VALUE obj2)
{
    return Qtrue;
}
```

[View on GitHub](https://github.com/ruby/ruby/blob/16294913f71b8a38526096cf6458340b19b45f9f/object.c#L1247)

Thankfully, this is one of the simplest examples of Ruby's C source you'll come
across. Though it's simple to read, the nuance of what is going on here is a
little more complicated. The **true_or** method is simply a method that takes
two arguments (actually only one really since the first argument will always be
the **true** singleton), and regardless of what those arguments are, returns
**true**. What may not be completely obvious from this code is how this method
implementation leads to the eager evaluation of the right-hand side of a logical
expression.

Throughout this article we've treated **|** like a primitive operator, perhaps
if we treat it more like a method call, it will make it more obvious how this
simple method equates to eager evaluation. Let's consider something along the
lines of the simplest possible case and while we're at it, let's see if
**||** is also implemented as a method on **TrueClass**. Let's see what happens
if we try to use **Object#send**:

```ruby
true.send("||", true)
# => NoMethodError: undefined method `||' for true:TrueClass

true.send("|", true)
# => true
```

Interesting! So we've learned that **||** is not a method, but must be a more
primitive operator. Additionally, we can see much more clearly now that **|** is
definitely a method of **TrueClass**.

With some closer examination, this example should also help make it clear how
implementing **TrueClass#|** as a method call leads to eager evaluation. Though
the argument we passed to **TrueClass#|** in the example above was a primitive
**true** value, it could have been any arbitrary Ruby expression. Unlike **||**
which could completely ignore the right-hand side of the expression when the
left-hand side of the operation is **true**, **TrueClass#|** cannot skip the
right-hand side of the expression because it is a method call. In fact, before
**TrueClass#|** is invoked, the RubyVM has already evaluated the right-hand side
of the expression, reducing it to the value that will be used as the argument to
**TrueClass#|**.

So, that's the magic behind one of the eager bitwise Boolean operators, what
about one of the bitwise Boolean operators? How is that implemented? Is it
also a method call? As it turns out, yes. Consider the implementation of
**TrueClass#&**:

```ruby
static VALUE
true_and(VALUE obj, VALUE obj2)
{
    return RTEST(obj2)?Qtrue:Qfalse;
}
```

[View on GitHub](https://github.com/ruby/ruby/blob/16294913f71b8a38526096cf6458340b19b45f9f/object.c#L1225)

Thankfully, this method is also pretty easy to read. It's a little more
complicated than **TrueClass#|**, but it's pretty easy to see that the method
evaluates the **RTEST** macro on **obj2** and returns **true** or **false**
depending on the outcome of that evaluation. I won't go into the inner workings
of **RTEST**, but you can view [the C source for the **RTEST** macro here](https://github.com/ruby/ruby/blob/01195a202cb9fcc6ddb6cf793868e4c7d85292dc/include/ruby/ruby.h#L422)
if you're interested. Basically, **RTEST** uses a couple of numeric bitwise
operations to determine if its argument is **false** or **nil** and if not
returns **true**, which in turn causes **true_and** to do the same.

Okay, so given all that, it should make more sense that using a bitwise/eager
Boolean operator would be slower than a more primitive operator. Unfortunately
though, slower execution is not the only drawback of these these method-based
bitwise Boolean operators.

# Inconsistent precedence

The fundamentally different nature of the method-based bitwise Boolean
operators and the more primitive logical Boolean operators is unfortunately not
without consequence. The overhead of a method call is only one consequence.
Another consequence is that the bitwise Boolean operators have a different
precedence than their logical cousins.

I won't get into the nature of [precedence, or order of operations,](https://en.wikipedia.org/wiki/Order_of_operations)
in this article, but I will offer these examples for your consideration:

```ruby
true || 1 && 3
# => true

true | 1 && 3
# => 3

# wtf?
# `true || 1 && 3` evaluates like `true || (1 && 3)` while
# `true  | 1 && 3` evaluates like `(true | 1) && 3`


false && true ^ true
# => false

false & true ^ true
# => true

# wtf?
# `false && true ^ true` evaluates like `false && (true ^ true)` while
# `false  & true ^ true` evaluates like `(false && true) ^ true`
```

As if the bitwise Boolean operators didn't have enough going against them, the
differences in operator precedence reek too much of a 4-hour debugging session
for my taste.

## The case against bitwise Boolean operators

Though I started this article with an agenda for finding a use-case appropriate
for eager Boolean operators, the search for such a use-case has ultimately led
me to the opposite end of the spectrum. Where once I sought to bring light to
eager Boolean operators, I now find myself at odds with the whole family of
bitwise Boolean operators. We've been through many of the arguments against, but
here they are again, in summary:

- Rare usage in community code suggests limited understanding and familiarity
- The primary benefit of eager evaluation is side effects.
  - Side effects make the code harder to debug, harder to reason about, and
    harder to test.
- Errors encountered during eager evaluation occur before assignment operations
  - Even if errors during eager evaluation are caught, the value of the logical
    expression is lost.[^2]
- Bitwise Boolean operators have too many differences from their logical
  counterparts.
    - Return values are converted to Booleans
    - Operator precedence is different
    - Operators are implemented as method calls, which are about 10% slower
    - Can only be invoked on **true**, **false**, or **nil**

With such an abundance of arguments against, arguments in favor had better
be significant in length or benefit. Unfortunately, they're not.

- Conversion of return values to Booleans slightly faster than double negation.
- Eager evaluation?
  - Maybe useful in irb?

I didn't expect to find so many reasons not to use eager or bitwise Boolean
operators, but maybe that's part of the reason I had so much trouble finding
examples of bitwise Boolean operators at large. With the evidence laid out
before you, I hope you will join me in continuing to never use any of the
bitwise Boolean operators in Ruby without a comment and a damn good reason.

Thanks for reading!

*Have I missed something? Do you know of an example of bitwise and/or eager
Boolean operators being used effectively? Have I got it all wrong? Leave me a
comment and let me know! I'd love to hear your feedback and/or find a
legitimate reason to utilize the family of bitwise Boolean operators.*

[^1]: [Short-circuit evaluation - Support in common programming languages](https://en.wikipedia.org/wiki/Short-circuit_evaluation#Support_in_common_programming_languages)
[^2]: [Gist: Errors during eager evaluation cause result of logical expression to be lost](https://gist.github.com/tdg5/12eccaae6132e72c0490)
