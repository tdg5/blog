---
author: Danny Guinther
categories: [dev/ruby/design patterns]
featured_image:
  alt_text: Module Factory Assembly Line
  title: Module Factory Assembly Line
  url: /assets/images/featured/2015-02-03-dependency-and-load-order-management-using-the-module-factory-pattern.jpg
layout: post
permalink: /dependency-and-load-order-management-using-the-module-factory-pattern
tags: [dependency injection, design patterns, factory method, idiomatic ruby, module factory, ruby idioms, ruby]
title: Dependency and Load-Order Management Using the Module Factory Pattern
---
At last year's RubyConf in San Diego, [Craig Buchek](https://twitter.com/craigbuchek)
gave a presentation entitled [Ruby Idioms You're Not Using Yet](https://www.youtube.com/watch?v=hc_wtllfKtQ),
focusing on some of Ruby's under-utilized and emerging idioms. In this post
we'll discuss one of those idioms, an idiom Craig appropriately calls **Module
Factory**. In particular, we'll explore the using a Module Factory as a pattern
for dependency and load-order management.

## Hey! Who you callin' an idiom?

For those unfamiliar with idioms or, more likely, unfamiliar with what idioms
refer to in the context of a programming language, Craig presents a number of
different perspectives, my favorite of which is:

> A style or form of expression that is characteristic of a particular person,
> type of art, etc.[^1]

Craig also offers his own perspective, which I think helps clarify and distill
this concept further:

> A way in which we normally express ourselves in a language.

Though I think this definition captures the idea nicely, I think there's a pearl
of enlightenment to be found in reducing the concept down to its roots:

> Late Latin idioma, idiomat-, from Greek, from idiousthai, to make one's own,
> from idios, own, personal, private.[^2]

I find this etymology charming because while formal definitions tend to focus on
existing patterns of language belonging to specific communities and cultures,
the origin of the word hints at a deeper essence that leads ultimately to the
cradle of all idiomatic expression: idioms are an emergent behavior of the
efforts of individuals and communities to make a language their own.

## Idioms in Ruby

In terms of Ruby, let's take a look at a couple of concrete examples of common
Ruby idioms juxtaposed with their less idiomatic counterparts to give ourselves
some grounding. Hopefully you'll agree that within each example, each variation
gets further and further from how you'd expect to see an idea expressed in Ruby.

###### Conditional assignment:
```ruby
# Idiomatic Ruby
a ||= b

# Less idiomatic
a || a = b

# And lastly, please don't do this
a = b if a == nil || a == false
```

###### Sequential iteration
```ruby
# Idiomatic Ruby
5.times { |i| puts i }

# Less idiomatic, though more performant
i = 0
while i < 5
  puts i
  i += 1
end

# And finally, the dreaded `for` statement
for i in 0..4
  puts i
end
```

Hopefully, these examples give you a good idea of idioms in Ruby, but if not,
I'd encourage you to watch [Ruby Idioms You're Not Using Yet](https://www.youtube.com/watch?v=hc_wtllfKtQ),
as it provides more examples which may help to further elucidate the concept.

On with the show!

## Module Factory: An Introduction

The Module Factory pattern as described in the presentation constitutes the use
of some variety of [Factory Method](https://en.wikipedia.org/wiki/Factory_method_pattern)
in place of a reference to a concrete Module when calling **extend** or
**include** from a Class or a Module. This is a fairly technical description, so
let's take a look at the example the presentation uses to demonstrate this
pattern. This example comes from the README for the [Virtus gem](https://rubygems.org/gems/virtus):

```ruby
class User
  include Virtus.model(:constructor => false, :mass_assignment => false)
end
```

[View on GitHub](https://github.com/solnic/virtus/blob/e648e2fe771d715179bddb7b0df9b0169a295ae3/README.md#cherry-picking-extensions)

Though it may be unclear what is going on here, if we trust that neither the
[Virtus docs](https://github.com/solnic/virtus/blob/e648e2fe771d715179bddb7b0df9b0169a295ae3/README.md#cherry-picking-extensions)
nor the Ruby docs for [Module#include](http://www.ruby-doc.org/core-2.2.0/Module.html#method-i-include)
contain an error, we can use a little deduction to piece together what's going
on:

- Though the Ruby docs aren't totally explicit about it, **Module#include**
  will raise an error unless given one or more Modules. From this we can infer
  that **Virtus.model** must be returning one or more Modules.
- A little trial and error in irb further uncovers that though
  **Module#include** supports being invoked with multiple Modules, these Modules
  cannot be provided in an Array, but must be normal method arguments (or in the
  case of an Array, must be exploded with the [splat operator](https://endofline.wordpress.com/2011/01/21/the-strange-ruby-splat/#calling_methods)
  into normal method arguments). Since the Virtus docs don't use the splat
  operator, we can further narrow our inference to deduce that **Virtus.model**
  must be returning a single module.

Now that we have a clearer understanding of what's going on in this example, it
becomes easier to see how it fulfills our definition of a Module Factory:
Instead of referencing a concrete Module, **Module#include** is invoked with the
result of invoking the **Virtus.model** method. Furthermore, we've deduced that
**Virtus.model** must return a Module of some sort and given the arguments it
takes, it's safe to assume there's some sort of factory logic going on inside.
In fact, this Module Factory allows the including class to cherry-pick a subset
of Virtus' model extensions and include only those selected modules.

Alright! Not so bad, right? Now that we've got one Module Factory under our
belt, let's take a look at how the Module Factory patten can help with
dependency management and load ordering.

## A job for refactoring

In order to provide some context for our discussion, let's start with some example
code that I think could benefit from a refactoring to use the Module Factory
pattern. For the sake of brevity, this code is non-functional and skips many of
the details that don't impact our particular interests. That said, the code
below should have a familiar flavor to anyone who has worked with an
asynchronous job framework in the past, such as
[Resque](https://github.com/resque/resque),
[Sidekiq](https://github.com/mperham/sidekiq),
[Backburner](https://github.com/nesquena/backburner), or
[Rails' ActiveJob](https://github.com/rails/rails/tree/master/activejob).

The example code outlines the skeleton of a job class that performs some
undefined unit of work. For those unfamiliar with any of the job frameworks I
mentioned above, the typical usage pattern for such a framework tends to involve
subclassing a class provided by the job framework which encapsulates and handles
most of the required behaviors of a job. In the example below, this role is
filled by the fictitious class **JobFramework::Job**.

Generally, by subclassing a class like **JobFramework::Job**,
the subclass agrees to an interface contract that typically requires the
subclass to implement a **perform** method at the instance level. This pattern
is also followed in the example below, as can be seen by the **perform**
instance method on the **ImportantJob** class.

One final point worth discussing before getting into the example is that the job
classes provided by many job frameworks tend to provide an **around_perform**
method hook or similar functionality to allow for adding middleware-type
behavior around job execution in a generic, unobtrusive way. The example below
also borrows this pattern, however it can be inferred that **JobFramework::Job**
provides this behavior in a very naive manner that relies heavily upon the class
hierarchy and repeated calls to **super**.

OK, that should be enough background, on to the example!

**important_job.rb**

```ruby
class ImportantJob < JobFramework::Job
  # NineLives must be included before ExceptionNotification,
  # otherwise up to nine alert emails will be sent per failed
  # job and in many cases, exception notifications will be
  # sent when the job didn't actually fail!
  include NineLives
  include ExceptionNotification

  def perform(*args)
    # Important work
  end
end
```

**job_extensions.rb**

```ruby
module NineLives
  def around_perform(*args)
    retry_count = 0
    begin
      super
    rescue TransientError
      if retry_count < 9
        retry_count += 1
        retry
      else
        raise
      end
    end
  end
end

module ExceptionNotification
  def around_perform(*args)
    super
  rescue
    # dispatch an email notification of the exception
  end
end
```

Here's a quick rundown of what we can expect the lifetime of an execution of the
**ImportantJob** class to look like:

1. Some code somewhere else in the codebase calls **ImportantJob.perform**.
  This class level **perform** method is provided by **JobFramework::Job** as a
  convenience method to enqueue an **ImportantJob** to be completed
  asynchronously.
2. Elsewhere, a worker process, also typically running code provided by the job
  framework, pops the job off of the job queue and instantiates a new instance
  of the **ImportantJob** class with the provided arguments. The internals of
  the worker process then take steps to execute the job which causes the
  **around_perform** method of the instance to be executed. Normally, the
  invocation of **around_perform** would simply cause **ImportantJob#perform**
  to be executed, however, since we've overwritten **around_perform** a couple
  of times, the behavior in the example is not so simple. The first version of
  **around_perform** that will be executed, perhaps counterintuitively, is the
  version from the last module we included in **ImportantJob**, **ExceptionNotification.around_perform**.
3. **ExceptionNotification.around_perform** immediately calls
  **super**, but includes a rescue block that catches any errors that bubble up
  and, hypothetically, dispatches email alerts about those exceptions. The
  invocation of **super** triggers the **around_perform** method from the first
  module we included in **ImportantJob**, **NineLives#around_perform**.
4. **NineLives#around_perform** is more involved, but its goals
  are pretty simple: Similar to **ExceptionNotification.around_perform**, it
  calls **super** almost immediately but adds some special error handling that
  catches errors of the **TransientError** class. The error handling will retry
  the call to **super** up to 9 times if the **TransientError** exception
  continues to occur. After 9 times, the error will be raised up to
  **ExceptionNotification** at which point an email should be dispatched. The
  call to **super** this time around invokes the original **around_perform**
  method, **JobFramework::Job#around_perform**, which as we discussed earlier,
  invokes **ImportantJob#perform**.

Now that we've got a solid understanding of the example job, let's see how using
the Module Factory pattern could benefit this class.

## What's wrong with a well written comment?

You may already have an intuition for where we should begin our refactoring to
introduce a Module Factory, but if you don't that's fine too. Personally, I'm
inclined to start with the very first line of the **ImportantJob** class. No,
not **include NineLives**. The honking four line comment that explains why the
**NineLives** module must be included before the **ExceptionNotification**
module. In a small enough codebase, the current form of **ImportantJob** might
be fine, but if that codebase is likely to grow, or if the codebase is already
of reasonable size, I'd argue that the comment and the rigid load-order are bad
news.

You may have your own arguments for or against the current implementation, but
here are my arguments against:

- That whopper of a comment is going to be repeated in every other job class
  that uses both the NineLives and ExceptionNotification modules (and if it's
  not, it should be). Trust me, I've seen it happen. Not only is this a
  violation of [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself),
  but because it's a comment it's pretty likely to mutate and/or deteriorate
  with each subsequent duplication. Eventually this leads to a situation
  where a newcomer to the code base doesn't know which version of the comment is
  accurate, or, alternatively, you end up with some job classes that tag
  **include NineLives** simply with "Must be included before
  ExceptionNotification" and no additional explanation. After this reduction,
  the comment starts to disappear entirely.
- Without the comment, there is no other clue that there is a load-order
  dependency between these two modules. Obviously, this is why the comment was
  added, but a comment can't help the situation where a job class that already
  includes **NineLives** now needs to include **ExceptionNotification**, or vice
  versa. If the dev making the change is lucky enough to have seen the comment
  elsewhere in the codebase, or another dev happens to catch the issue in a code
  review, maybe you can avoid a Spam dinner, but if not, it's
  Spam-a-lam-a-ding-dong until the next deploy goes out.
- What happens when another load-order dependency is added with the inclusion of
  a new module? Another giant comment in every class that needs some combination
  of the three modules? One giant comment that tries to encompass all the
  permutations in a generic fashion? How would you feel if the purpose of the
  **ImportantJob** class was to perform a payment on a loan and the newly
  included module was added to lower someone's credit score every time an
  exception bubbled out of **NineLives#around_perform**? It's a bit of a
  stretch, but don't think that financial systems are immune to these
  situations, and I certainly hope they're using a better design than repeated
  comments.

One could certainly make the argument for handling this issue by introducing
another module to encapsulate the load-order dependency, but in my experience
that doesn't actually solve any of these problems, but instead, it just moves
the problems into other parts of the codebase or mutates them into slightly
different issues.

While we could explore alternative solutions for handling this situation all
day, let's move on and get an idea of how a Module Factory could be used to
address all of the concerns I've raised.

## A Module Factory for job extensions

Before we look at how me might go about implementing a Module Factory to address
the issues I raised above, let's take a look at what **ImportantJob** might look
like after we refactored it to use a Module Factory.

```ruby
class ImportantJob < JobFramework::Job
  include JobExtensions.select(:exception_notification, :nine_lives)

  def perform(*args)
    # Important work
  end
end
```

We have to make some assumptions for now, but hopefully you'll agree that this
is already a significant improvement.

We can't yet make a determination on the ultimate fate of the comment because
it's no longer included in **ImportantJob**, but this by itself is a good sign.
Realistically, I don't think there was ever hope of going completely comment
free, but, at least for the moment, things have a much DRYer feeling.

Otherwise, there's still no hint that a load-order dependency exists somewhere,
but given the order of the arguments to **JobExtensions.select**, we can hope it
doesn't matter anymore. If the order of the arguments truly doesn't matter, than
this also helps the situation where someone wants to add **ExceptionNotification**
to a class that already includes **NineLives**, as it seems like they could just
add the snake-cased name of the extension to the list of selected extensions and
continue on their way. The same applies for any new extension that might be
added in the future. In fact, the use of the snake-cased names actually involves
less coupling than the original version because though the snake-cased names
match the module names in this case, there really is no need for the module name
and the snake-cased name passed to the factory method to match. This means that
the module implementing :nine_lives could change to an entirely different module
with fewer repercussions to the codebase.

So far, so good. So what kind of sorcery is required to make this interface
possible? Behold! The **JobExtensions** module:

```ruby
module JobExtensions
  def self.select(*selected_extensions)
    Module.new do
      # NineLives must be included before ExceptionNotification,
      # otherwise up to nine alert emails will be sent per failed
      # job and in many cases, exception notifications will be
      # sent when the job didn't actually fail!
      if selected_extensions.include?(:nine_lives)
        include NineLives
      end
      if selected_extensions.include?(:exception_notification)
        include ExceptionNotification
      end
    end
  end
end
```

Maybe a little magical, but certainly not sorcery, in fact it looks a lot like
we took the comment and includes from the former version of **ImportantJob**,
added some conditional logic, and wrapped all that in a **Module.new** block.
What's going on here?

I suspect I don't need to explain the internals of the block, but **Module.new**
is definitely worth taking a closer look at on its own.

[Module.new](http://www.ruby-doc.org/core-2.2.0/Module.html#method-c-new), is
the more metaprogramming-friendly version of your standard module declaration
using the **module** keyword. In fact, when used with a block, it's even more
similar to a standard module declaration than might be obvious because in the
context of the block the target of **self** is the module being constructed.
This behavior is what allows us to make normal calls to **include** without
having to use an explicit receiver or having to call **send**.

For our particular purposes, **Module.new** does offer one advantage over the
**module** keyword worth mentioning. Because **Module.new** uses a block, a
closure is created that allows us to reach outside of the block and access the
list of **selected_extensions** while building the new module. Access to this
list is crucial to our Module Factory's ability to build a customized module on
demand. Without access to the list we'd have to figure out another way to
assemble the desired module, which is certainly doable, but would be less
pleasant to look at and would require using **send** to circumvent the generated
module's public access rules.

Other than the call to **Module.new**, I expect everything else in this factory
method should make sense. We've found our missing comment and can be fairly
confidant that in this form it's unlikely to be repeated. If it is repeated in
the future, it will likely be a modified version that documents the load-order
gotchas of a different extension that this Module Factory supports. While there
is probably a better way to document the specifics of this particular load-order
requirement, I'm much less concerned with many similar comments documenting
similar behavior inside a particular method than I am with the same spread all
across the codebase in any number of unaffiliated jobs.

## Before you get too excited: A couple of trade offs

Though the Module Factory we've built certainly helps deal with handling the
load-order logic in a DRY fashion, there are a couple of potential trade offs
that I should mention. These issues can be addressed, but I won't go into great
detail about how to address them. The good news, though, is that both trade offs
are solved by pretty much the same code.

The first trade off is that generating a module dynamically like we did above
produces a more anonymous module than you might be used to seeing if you usually
create modules using the **module** keyword. For example, here's the fictitious
ancestry of the **ImportantJob** class:

```ruby
ImportantJob.ancestors
# => [
#      ImportantJob, #<Module:0x00000000e39c48>,
#      JobFramework::Job, Object, Kernel, BasicObject
#    ]
```

That funky Module between **ImportantJob** and **JobFramework::Job** is our
generated module. Though we've handled the load-order issue in a more robust
fashion, we've obscured the class hierarchy which makes it harder to find
information about the class via interrogation or examination.

To get some insight into the second trade off introduced by the Module Factory
pattern, let's pretend we've created another job class, **ReallyImportantJob**,
that is an exact duplicate of **ImportantJob**, except named differently. What
does the class hierarchy for **ReallyImportantJob** look like?

```ruby
ReallyImportantJob.ancestors
# => [
#      ReallyImportantJob, #<Module:0x00000000d4a058>,
#      JobFramework::Job, Object, Kernel, BasicObject
#    ]
```

What may not be clear from this output is that though the two job classes are
made up of the exact same code and modules, each generates its own special
module when the **JobExtensions.select** factory method is called. This can be
seen in the output above in that the each of the generated modules is identified
by a different memory address. This might not be the end of the world in a small
codebase, but it should make it clear that every class is going to generate its
own version of the module, even if one matching the requested requirements
already exists. This is obviously inefficient in terms of time and memory, but
it also adds another complication to understanding a class by interrogation or
inspection because though another dev might expect the class hierarchies of
**ImportantJob** and **ReallyImportantJob** to include the same modules, they
don't, but they do, but they don't.

So what's the solution? Well, it turns out both issues can be solved by dealing
with some naming issues. In terms of the first trade off, the anonymous module,
Ruby uses an anonymous name because we never assigned the module to a constant.
This is one of the implicit benefits of the **module** keyword: you assign the
module to a constant at inception. So, if we can come up with a way to generate
a name for the generated module, all we need to do is assign a constant with the
generated name to point to the generated module and Ruby will use that name to
refer to the generated module.

Though it's not obvious, generating a name also helps us to address the second
trade off of generating a new module every time the factory method is invoked. A
name helps solve this problem because if we can generate a name that uniquely
identifies the contents of a generated module and assign the appropriate
constant, we can also check that constant in the future before generating a new
module. If the constant is defined, we return the previously generated module,
if not, we generate a new module and assign it to the constant.

In terms of our example job, the actual implementation is left to the reader as
an exercise, but generating a name that uniquely identifies each generated
module could be as simple as creating a string from the sorted, title-cased
collection of extensions that are used in the module being named. Title casing
is important for readability, consistency, and so Ruby will accept the name as a
constant.[^3] Sorting is also important because, at least in the case of our
example, we don't want the order of the arguments to change the name of the
class being created because whether **:exception_rety** is passed in before
**:nine_lives**, or vice versa, both invocations should generate and refer to
the same module. This naming pattern still has some problems because it is still
unclear what the module does, but it is at least a little better than the module
being identified by its raw memory address.

## Closing thoughts

Though it may not feel like it, this post has really only scratched the surface
of the power and potential of the Module Factory pattern. Though we've discussed
how it can be used to improve code readability, maintainability, reliability, and
flexibility, there's really a lot more opportunity out there. And so, rather
than summarize what we've covered in this post, I'll leave you to ponder these
possibilities:

- As evidenced by [Kernel#Array](http://www.ruby-doc.org/core-2.2.0/Kernel.html#method-i-Array)
  and [Kernel#Integer](http://www.ruby-doc.org/core-2.2.0/Kernel.html#method-i-Integer)
  Ruby doesn't require method names to start with a lowercase letter. How might
  a method with a title-cased name be used to compliment the Module Factory
  pattern? Are there trade offs that come with this type of naming convention?
- Ruby method names don't need to be words at all, take for example
  [Hash::[]](http://ruby-doc.org/core-2.1.5/Hash.html#method-c-5B-5D). How might
  an operator style of method name pair with the Module Factory pattern? 
- How else could the power of a method call be leveraged for Module Factory
  awesomeness? What magic could be yielded (pun intended!) by a factory method
  that takes a block? How might keyword arguments, Hash arguments, or splat
  arguments be leveraged in combination with a Module Factory?
- If you've ever used a framework that uses dependency injection like
  Javascript's AngularJS, then the examples above may have caused your Spidey
  sense to tingle. How might the Module Factory pattern be used for dependency
  injection in Ruby?

[^1]: Source: [Merriam-Webster](http://www.merriam-webster.com/dictionary/idiom)
[^2]: Source [thefreedictionary.com](http://www.thefreedictionary.com/idiom)
[^3]: A third-party library like [**ActiveSupport**](https://rubygems.org/gems/activesupport) can make the work of title casing the string trivial.
