---
author: Danny Guinther
categories: [dev/ruby/journeyman]
featured_image:
  alt_text: Meditation Cairn Atop Rippling Waters
  title: Meditation Cairn Atop Rippling Waters
  url: /assets/images/featured/2015-02-16-on-the-road-from-ruby-journeyman-to-ruby-master.jpg
layout: post
tags: [journeyman, project euler, ruby, ruby journeyman, ruby newbie, rubyist, self-reflection]
title: On the Road From Ruby Journeyman to Ruby Master
---
Mind-blowingly awful are really the only words that come to mind to describe my
first bunch of Ruby scripts.[^1] Sure, this is probably unfair and over-critical
given that Ruby, algorithms, and the whole shebang were all new to me at the
time, but *damn*. There are so many decisions I can't even begin to comprehend
or defend today.

I imagine few Ruby devs still have their first scripts available to reflect on.
This may be for the best, yet, as I looked over a few of my early scripts this
past weekend, I began to ponder the value of occasionally revisiting old code
samples to better gauge one's progress and get a periodic sense of perspective.
Similarly, I also found myself contemplating the value of occasionally taking a
step away from production code to draw a new line in the sand recording one's
state as a developer in that moment; A coded testament of one's values, whether
in terms of syntax, tradeoffs, or any number of other metrics; a mile marker
somewhere along the road from Ruby journeyman to Ruby master.

To that end, in this article I'll be sharing and discussing one of those early
scripts. From there, I'll also leave behind a new mile marker by taking a stab
at how I might solve the same problem today. With any luck, we'll all learn
something along the way, and if not, it seems like I'll be back to rant about
the inferior quality of my past work in no time. For now though, onward!

## When Danny met Ruby...

Back in 2009, at the encouragement of my stepfather who thought the future had
great things in store for Ruby and Rails (boy, was he wrong!), I began to
explore the Ruby programming language by trying to solve a few of the math heavy
programming problems over at [Project Euler](https://projecteuler.net/). Up
until this point, I'd only ever done any "programming" in Basic and Visual
Basic, as these were the focus of the programming courses taught at my high
school. I'd argue that I got pretty advanced in my usage of Visual Basic, going
so far as to develop a reasonable grasp on the Win32 API, but given my present
distaste for my early Ruby code, I can only imagine that my earlier VB code must
have been transcendently awful. In VB, I'd only ever written small utilities and
weak attempts at games, so using Ruby to efficiently solve what were essentially
math problems was new territory for me.

For each problem that I attempted, I followed two rules. First, and obviously,
the computed solution had to be correct. Second, the script had to run to
completion in less than one minute. I don't remember if the second rule was
stipulated from the beginning or if my naive tendency toward brute-force
solutions prompted my stepfather to introduce the rule, but I definitely
remember struggling to get my scripts to run in less than a minute at various
times. For anyone getting started with this type of endeavor, it's definitely a
great constraint to have in place. That said, the problem we're going to look at
today isn't one of those long running problems, in fact, even my early attempts
at solving the problem take less than a second to run. Let's have a look, shall
we?

## Problem 8: Largest Product in a Series

Though it's not the first problem I solved, [Problem 8: Largest Product in a
Series](https://projecteuler.net/problem=8), seems like a problem of sufficient
complexity to merit a bit of discussion. For your convenience here is the full
text of the question:

>The four adjacent digits in the 1000-digit number that have the greatest
>product are 9 × 9 × 8 × 9 = 5832.
>
> 73167176531330624919225119674426574742355349194934  
> 96983520312774506326239578318016984801869478851843  
> 85861560789112949495459501737958331952853208805511  
> 12540698747158523863050715693290963295227443043557  
> 66896648950445244523161731856403098711121722383113  
> 62229893423380308135336276614282806444486645238749  
> 30358907296290491560440772390713810515859307960866  
> 70172427121883998797908792274921901699720888093776  
> 65727333001053367881220235421809751254540594752243  
> 52584907711670556013604839586446706324415722155397  
> 53697817977846174064955149290862569321978468622482  
> 83972241375657056057490261407972968652414535100474  
> 82166370484403199890008895243450658541227588666881  
> 16427171479924442928230863465674813919123162824586  
> 17866458359124566529476545682848912883142607690042  
> 24219022671055626321111109370544217506941658960408  
> 07198403850962455444362981230987879927244284909188  
> 84580156166097919133875499200524063689912560717606  
> 05886116467109405077541002256983155200055935729725  
> 71636269561882670428252483600823257530420752963450  
>
> Find the thirteen adjacent digits in the 1000-digit number that have the
> greatest product. What is the value of this product?

It's worth noting that the requirements of the problem were modified in 2014 to
encourage more programmatic solutions to the exercise. More specifically, the
question originally asked for the largest product of not 13 adjacent digits but
of just 5 adjacent digits in the 1000-digit number. A minor difference, but one
that will, at the very least, help better explain at least one of the decisions
I made in my 2009 solution.

To that end, a modified version of my 2009 solution appears below. The solution
has been modified from its original form in two ways. First, as necessitated by
the change in the problem requirements, the solution has been extended, in a
manner consistent with the original solution, to handle runs of 13 digits.
Second, rather than repeat the 1000-digit number, we will assume it is stored in
the constant NUMBER as a Bignum. I won't explain the solution, but hopefully my
discussion of it should help fill in any gaps in understanding. Instead, I'll
jump right into my thoughts on the shortcomings of this script.

### 2009 Edition

```ruby
a=NUMBER.to_s
big = 0
for i in 1..(987)
  su=a[i,1].to_i*a[i+1,1].to_i*a[i+2,1].to_i*a[i+3,1].to_i*a[i+4,1].to_i*a[i+5,1].to_i*
    a[i+6,1].to_i*a[i+7,1].to_i*a[i+8,1].to_i*a[i+9,1].to_i*a[i+10,1].to_i*a[i+11,1].to_i*
    a[i+12,1].to_i
  if su>big
    big=su
  end
end
puts big
```

#### Where's the whitespace?

The first thing that strikes me about this script, and many of the others I've
reviewed from this period, is the omission of optional spaces. This is one of
those situations where I can't even begin to understand what I was thinking.
Given that I do add optional spaces in at least one place, we can rule out the
possibility that my spacebar was broken. This being the case, I'm inclined to
believe I simply wasn't thinking about it, but it seems so blatantly obvious to
me now that I find this hard to believe.

It is certainly possible that I had no notion of (or concern for) readability.
It's also possible that my mental parser was in a sufficiently unformed,
immature, or plastic state that the omission of optional spaces felt as readable
to me then as when optional spaces were included. This seems a bit unfathomable
now, but that's really all I can come up with.

In the JavaScript world, you will sometimes see libraries that achieve some feat
in less than 1KB or some other very minimal file size. In JavaScript, where
libraries are typically transmitted over the wire to web browsers across the
world, this type of optimization can be desirable to reduce the size of the
payload being transmitted (though it really should be the job of a minifier).
But in Ruby, where libraries typically live on the server, there is no benefit
to this type of optimization as far as I'm aware. If there is a benefit to this
approach that I am unaware of, I can assure you it's not what I was striving for
at the time.

#### Hmm, seems like a loop might help...

Next on my list of grievances is the ginormous series of substring accesses of
the form **a[i+n, 1]**. First, let's get it out of the way that the second
argument to **String#[]** is totally useless here, being as it is that the
default behavior is to return the 1-character substring located at the index
given by the first argument. Normally, this might be an excusable offense, but
given that this snippet could benefit from some serious DRYing, it's a little
more intolerable because the extraneous argument would have to be removed in 13
different places.

Given that this seems like an obvious situation for a loop of some sort, why the
no loop? In this particular case, I do have some recollection of my thinking,
and I'm fairly certain that forgoing a loop was a conscious decision. If you'll
recall, the problem at the time was concerned with 5 consecutive digits instead
of 13 which made the repeated code a little more manageable and perhaps even
tolerable.

At the time, I may have hoped to gain some performance by skipping the loop and
retrieving each element directly, though this concept seems like it would have
been too advanced for my thinking at the time. Instead, I'm inclined to believe
that I may have chosen five direct accesses because it was easier for me at the
time than setting up a loop, though I'm not sure. Though skipping the loop is a
teensy bit faster, it's clearly not DRY and it also hardcodes an implicit over
specification into the solution that makes it very difficult to change the
length of the series of adjacent digits that should be tested. As such, to
update the code to test a series of 13 digits, I had to more than double the
number of element accesses, moving the code even further from the goals of DRY.

If it's not already clear, using a simple loop would have been a better choice.
Though insignificantly slower, a simple loop would make the code much DRYer
while also enabling the solution to be more generic. This would better prepare
the solution to handle any number of adjacent digits while also making the code
easier to read, follow, and understand. Generality definitely wasn't something
that was on my mind in solving this problem as we'll see again in a moment.

#### Maybe one loop was a better choice...

Though we can hopefully agree that it seems like a loop would have been a better
choice in the situation above, there are enough problems with that loop already
used that it starts to seem like utilizing another loop might not have been a
good idea. The loop already in use is a **for loop** operating over a range of
Integers that allows for traversing the vector of digits. There are a number of
things about this loop that are less than ideal, some more obvious than others.

One thing that may stick out to more experienced Rubyists is the choice of a
**for loop** over other alternatives. Though not technically wrong, the **for
loop** is not commonly seen in Ruby and typically more idiomatic loop primitives
are used instead. Another thing that may stick out to more experienced Rubyists
is the unnecessary use of parentheses around the terminal Integer or upper bound
of the Range expression. Again, not wrong per se, but certainly an indicator of
my noob status and perhaps an indicator that I didn't fully grok the Range
expression and perhaps thought I was calling a dot method on the Integer class,
like **Integer#.**, that returned a Range instance when invoked with an Integer
for an argument. Novel perhaps, but wrong.

Returning to the topic of generality, the loop also hardcodes **two** more
over-specifications into the solution that make the solution more rigid and less
reuseable. As if this weren't bad enough, the two over-specifications interact
with each other in such a way that it's not obvious what's going on. In fact,
they're both encapsulated in the seemingly random choice of 987 for the upper
bound of the Range. Being as astute as you are, I imagine if you were paying
attention to the problem description then you've already surmised that 987 is
none other than, 1,000, the length of the input digit, minus 13, the length of
the run of adjacent digits we're calculating the product of. This upper bound
makes sure our product calculations don't overflow the length of the provided
number. Duh, right?

Wrapped up there in one little number are three flavors of weak. First, the
hardcoded reference to 1,000 means we won't be able to reliably use this solution
on a similar problem that features a number that is anything other than exactly
1,000 digits.  Second, the hardcoded reference to 13 means yet another place an
update will be required in order to mutate the solution to handle runs of
lengths other than 13. Finally, both of these facts are obscured by the use of
the precalculated value of 987 for the upper bound of the range.  Instead of
hardcoding the value, calculating the upper bound by taking the difference of
the length of **NUMBER** and the desired length of adjacent digits would be
better. Having no reliance on knowing the length of **NUMBER** would be even
better, if possible.

One final point about the loop before we move on: it's wrong! Given the
magnitude of the wrongness, you may prefer to think of it as a bug, but at the
end of the day, it's just plain old wrong. The problem is that the Range starts
at 1, which translates to index 1 of the stringified **NUMBER**. Starting with
index 1 means that the digit at index 0 is totally ignored, which means that if,
by some chance, the 13 consecutive digits with the largest product were the
first 13 digits, this solution would fail to find the correct product. Whether
you call this a bug or broken, it's bad news. So yeah, maybe one loop was the
way to go.

#### A final look back at 2009

Before we look at how I might solve this problem today, I want to make two final
points about my 2009 solution. First, the variable names suck. The only variable
name that comes close to being tolerable is **big**, and even that isn't great.
Finally, a compliment. Despite all of its problems, my 2009 solution does excel
as example of the lowest of low Ruby newbie code. Certainly, that's a
back-handed compliment, but I really could not have written an example like this
today if I wanted to: it simply would have felt far too contrived.

With the past firmly behind us, let's take a look at how I might solve this
problem today.

### Solution 2015

```ruby
# Project Euler #8 - Largest product in a series
# https://projecteuler.net/problem=8
#
# Find the thirteen adjacent digits in the 1000-digit number that have the
# greatest product. What is the value of this product?

def largest_product_in_series(number, adjacency_length = 13)
  series = number.to_s
  zero_ord = '0'.ord
  factors = []
  largest_product = 0
  current_product = 1
  series.each_char do |new_factor|
    # This String-to-Integer conversion assumes we can trust our input will only
    # contain digits. If we can safely assume this, calling String#ord and then
    # subtracting the ordinal of the String '0' will work faster than
    # String#to_i.
    new_factor = new_factor.ord - zero_ord

    # If our new_factor is zero, we know that the product of anything
    # currently in our collection of factors will be zero. so, rather than
    # work through that, just drop the current set of factors, drop the
    # zero, reset our current product, and move on to the next iteration.
    if new_factor.zero?
      factors.clear
      current_product = 1
      next
    end

    factors << new_factor
    current_product *= new_factor
    next if factors.length < adjacency_length

    largest_product = current_product if current_product > largest_product
    current_product /= factors.shift
  end
  largest_product
end

puts largest_product_in_series(NUMBER)
```

I think I'm still too close to this solution to offer much objective criticism,
so though I'll touch on a few concerns later, for the most part, we'll leave
criticism to future-Danny to worry about. So, let's start by seeing how the
updated solution fairs in regard to some specific points that were brought up
while dissecting my 2009 solution. After that, we'll look at some new goodness
it brings to the table. Like the 2009 solution, I won't explain exactly what's
going on, but hopefully the discussion below and included comments will suffice
to convey the intention of the code.

#### Lessons learned

Here's a brief rundown of a few of the concerns I raised about the 2009 solution
and how those concerns have faired in the 2015 solution:

- Spacing is kind of funny in that you might not think about it if it's there,
  but if it's missing you'll definitely notice. Whether you noticed the
  additional white space or not, hopefully you'll agree that the use of
  consistent white space makes this solution much more readable than its
  counterpart.

- Variable names, like white space, can be a little funny too given how personal
  and subjective they tend to be. Whether you think the variable names used in
  the updated solution are great, too short, too long, or just a little off,
  hopefully we can all agree they are a significant improvement over the
  variable names of the 2009 solution.

- In terms of rigidity and over-specificity, the 2015 solution is much more
  flexible and generic. It has no dependency on the length of the number given,
  meaning the provided number could be 1,000 digits long or 10,000 digits long.
  Though it still needs to know how long a run of digits should be tested, it is
  not hardcoded to a certain length. A default length of 13 is used, but this
  can easily be overridden by invoking the **largest_product_in_series** method
  with a specific value for **adjacency_length**. This means that we could
  answer both the original 5-digit version of the question and the updated
  13-digit version of the question with one algorithm.

- Because the solutions are so different, any discussion in terms of the number
  of loops is somewhat moot, however the loop used in the 2015 solution does
  have one characteristic that I'd previously suggested could be desirable: it
  does not depend upon knowing the length of **NUMBER**. Instead, it iterates
  over every character in the String derived from **NUMBER**, **series**, using
  String#each_char. In this case, we still know **series** comes from the full
  **NUMBER** so, we're not a lot closer to a solution that would work for true
  streams of numbers, but the length agnostic nature of the loop is a step in
  the right direction.

- One other big improvement included in the updated solution that we didn't
  mention in terms of the 2009 solution is the addition of comments. There are
  two flavors of comments in the updated solution that help provide clarity to
  the solution. First, the problem description is included as a comment at the
  head of the solution. This is really handy for someone else looking at the
  code or for coming back to the code six years later. Second, comments
  explaining some of the solution's logic have been added making it easier for a
  reader to understand what is going on and why those decisions were made.

#### An alternate approach

Beyond the better coding practices exhibited by the 2015 solution, the solution
also leverages a better approach to solving the problem. Better can be somewhat
subjective, so I should be clear that in this case I think the 2015 solution is
superior because the algorithm is more efficient and offers a performance
improvement of about an order of magnitude while still using about the same
amount of memory. The concept for the alternate approach emerged from two
seemingly unrelated notions, each of which I thought could be useful
independently to squeeze some extra performance out of the algorithm. As it
turns out, they weren't completely independent notions and one is actually much
easier to implement when built on top of the other.

The first idea for optimization revolved around a means to more efficiently
calculate the new product each iteration. While the 2009 solution calculated the
new product each iteration by performing 12 multiplications, I reasoned that
since we're really only changing two numbers each iteration (the digit going out
of focus and the digit coming in to focus), it should be possible to calculate
the new product with only two operations (divide out the digit going out of
focus, and multiply in the digit coming into focus). The only situation where
this would be complicated is when a zero was encountered because a zero would
effectively destroy our partial product when it got multiplied in, not to
mention trying to divide by zero later would also be a fatal error. A better
means of handling zeros would be required to calculate products in this manner
and that's just what the second idea offered.

The second notion I had for optimizing the algorithm stemmed from removing the
extraneous work that was being performed the iteration in which a zero was
encountered and the 12 subsequent iterations after. Because zero multiplied by
any other number is always going to be zero, there were effectively 13
iterations for every zero where the algorithm would do all the work despite the
fact that the answer was guaranteed to be zero. It seemed to me that there had
to be a way to avoid this extraneous effort and actually use zeros as a way to
speed up the calculation. As it turns out, handling zeros is pretty easy because
all that needs to be done when a zero is encountered is reset the partial
product to its initial value, 1, and move on.

With zeros taken care of, the more efficient means of calculating the product is
simplified to keeping a queue of the factors of the partial product. Then, each
iteration the digit going out of focus is removed from the queue and divided
out of the partial product and the number coming into focus is added to the
queue and multiplied into the partial product. One final bit of house keeping
that is required is that when a zero is encountered, the queue of factors must
be reset as well.

#### A faster Char#to_i

One final bit of hackery (of debatable merit) is the means by which the updated
solution turns the String form of a digit into its Integer form. Though
**String#to_i**, is the obvious candidate for this conversion, I wondered if
there might be a faster way since this problem has little need for error
checking or converting large strings of digits. If Ruby had a **Char** class
for single characters, **Char#to_i** would likely have a different performance
character than **String#to_s**, and a **Char#to_s** style approach was more what
I was looking for.

One way I had seen this done for individual numbers in other languages was to
take the ordinal, or character code, of an ASCII number and subtract from it the
ordinal for the character "0" to get the Integer equivalent of the character.
This is exactly what the updated solution does using **String#ord**. In each of
my trials, I found the **String#ord** trick to be 25-30% faster than
**String#to_i**. Whether using this trick is a good idea or not (given that this
method makes no checks to verify that the provided character is a number) is a
whole other blog post. In this particular case, I thought the approach novel and
performant enough to utilize it.

#### Still a Ruby journeyman: A few concerns

Before concluding this post, I want to mention a few concerns that have come to
mind as I've spent some time analyzing the updated solution. Most stem from
tradeoffs or implementation details. I can't help but wonder if a few of these
concerns are going to be the reasons future-Danny gives for this solution being
mind-blowingly awful in its own way.

- Did I put way too much effort into the updated solution? 2009 for all of it's
  shortcomings was much more pragmatic in that it was all about getting the
  correct solution and moving on. The goals of the 2009 solution and the 2015
  solution are clearly different, so maybe I put exactly the right amount of
  time into the updated solution. I suspect it's something only future-Danny
  will be able to make a ruling on.

- Should the solution include more/any error handling? The use of the
  **String#ord** trick certainly opens up opportunities for misuse. But even
  that hack aside, what happens when the number provided is shorter than the
  adjacency length? Currently it does a correct thing and returns zero, but
  should that raise an error instead? Is additional error handling worth the
  time?

- Why the focus on performance? Is performance really critical for this problem
  or is the focus on performance more to provide some concrete metric of how the
  efficiency of my programming has improved over the last 6 years? The
  **String#ord** trick is nice, but is it really worth the extra complexity,
  confusion, and possible bugs? What benefit might a simpler, less efficient
  solution offer?

- Should the **String#ord** trick be extracted into a method to make it easier
  to substitute a different means of converting a digit character into its
  Integer form?

- Why convert **NUMBER** to a String? For all the focus on performance, this is
  likely not the most efficient option. If **NUMBER** can remain a Bignum and
  each of the digits could be extracted from it in Integer form, would that be a
  more performant solution? Would it be a simpler solution?

- Why the long method format? Sandi Metz would likely argue for smaller methods,
  as would Martin Fowler. The long method was partly due to performance concerns
  and partly because **Replace Method With Method Object** seemed excessive by
  the time it made sense. That said, should this method be broken up into
  smaller methods encapsulated in a class of some sort?

## Happily ever after?

Though my exploration of Ruby, and the many other concepts secretly embodied by
the set of problems at Project Euler, didn't pay off in an obvious way at the
time I was focusing on them, I'm happy to have begun my career with Ruby
struggling to write efficient algorithms. Though a friend of mine, a Gopher
through and through, would argue that all Ruby is struggling to write efficient
algorithms, this is a sentiment I've never shared. Perhaps, our disagreement on
the subject stems from my beginnings with Ruby where any algorithmic
inefficiencies were almost always my own and not some fault of the language.
Though there is certainly an argument to be made for using the right tool for
the job, at least in the part of the stack I tend to work in, I have yet to come
across a situation where Ruby was clearly inappropriate. But maybe that's just
me defending an old friend.

In the end, I'm glad I've held on to my old Project Euler solutions because
though I wouldn't land my first Rails job until late 2011 and I'd spend two more
years on the Microsoft stack dabbling in C# and relational concepts in MSSQL,
and though, for a time, Ruby and I would talk less often, given our history
together, it's nice to be able to look all the way back to the beginning of my
time with Ruby. It helps me to understand that, frankly, I hope to always be
writing code that is four years away from being mind-blowingly awful. If this
stops being the case then I've stopped learning or I've stopped caring and
either way, that'd be pretty sad.

[^1]: I would **never** talk about another person's code in these terms, especially if that person was as junior as I was when I wrote these scripts. In the words of the [Ten Commandments of Egoless Programming](http://blog.stephenwyattbush.com/2012/04/07/dad-and-the-ten-commandments-of-egoless-programming), "Treat people who know less than you with respect, deference, and patience." I hope you too will follow this advice and save harsher criticisms for your own work.
