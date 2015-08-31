categories: [dev/design]
featured_image:
  alt_text: Lean Object-Oriented Design
  title: Lean Object-Oriented Design
  url: /assets/images/featured/2015-06-27-crafting-your-first-pry-plugin.jpg
layout: post
tags: [agile, lean, object-oriented, object-oriented design, oo]
title: Lean Object-Oriented Design
---
# Lean Object-Oriented Design

The principles of Lean software development and their influence on object
oriented design.

## Agile

[Launch Academy Blog - Product Development Lifecycle]

## [Lean Software Development][Wikipedia - Lean Software Development]

## [The Lean Principles][Wikipedia - Lean Principles]

### [Eliminate waste][Wikipedia - Lean Eliminate Waste]

> The cheapest, fastest, and most reliable components are those that aren’t
> there. [^1]  
[Gordon Bell][Wikipedia - Gordon Bell]

> I was joking the other week that we should have somebody whose job it is to
> follow every project and get notified of every pull request and just go into
> the thread and ask "Do you really need to do this?" You need that constant
> voice. [^4]  
[Joe Ferris - CTO at Thoughbot][Thoughtbot - Joe Ferris]

[DRY][Wikipedia - DRY]
[KISS][Wikipedia - KISS]
[YAGNI][Wikipedia - YAGNI]
[TDD][Wikipedia - TDD]

Lots you can do to help facilitate future change:

[SOLID][Wikipedia - SOLID]

Minimize coupling

[Creator][Wikipedia - GRASP - Creator][Wikipedia - GRASP - Creator]
[Loose Coupling][Wikipedia - Loose Coupling]
[Dependency Injection][Wikipedia - Dependency Injection]
[Dependency Inversion Principle][Wikipedia - Dependency Inversion Principle]

### [Amplify learning][Wikipedia - Lean Amplify Learning]

> Short feedback loops give us confidence. Confidence leads to enjoyment. I love
> driving my donkeys, and I love working on a software development team that is
> guided by continual quick feedback! Look how much fun this is! [^2]  
[Lisa Crispin - Agile Testing Coach and Practitioner][Lisa Crispin]

> Design is a process of progressive discovery that relies on a feedback loop.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

[Test-driven Development][Wikipedia - TDD] Provides feedback not just on when
things are broken, but on the quality of the design of your objects.
[Fail fast; learn rapidly][Lean Software Development - Fail Fast]

frequent client interactions, developer to customer interactions.
stand up

### [Decide as late as possible][Wikipedia - Lean Decide Late]

Prefer responding to change over following a plan.
[The Agile Manifesto][Wikipedia - Agile - Agile Manifesto]

> Any decision you make in advance of an explicit requirement is just a guess.
> Don't decide; preserve your ability to make a decision later. [^3]  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

> The more complex a system is, the more the capacity for change should be built
> into it.  
[Decide as late as possible][Wikipedia - Lean Decide Late]

> "What is the future cost of doing nothing today?"
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

> When the future cost of doing nothing is the same as the current cost, postpone
> the decision. Make the decision only when you must with the information you have
> available at that time.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

[DRY][Wikipedia - DRY]
[YAGNI][Wikipedia - YAGNI]

### [Deliver as fast as possible][Wikipedia - Lean Deliver Fast]

> Design is more the art of preserving changeability than it is the act of
> achieving perfection.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

> It's just so easy and fun to build a lot of software. Fixing bugs or spending
> a lot of time to figure out what is wrong and then tweaking the code to fix
> it, that's just not as fun as writing a lot of software. As developers who are
> excited about software, we're always tempted to do this. [^4]  
[Joe Ferris - CTO at Thoughbot][Thoughtbot - Joe Ferris]

[YAGNI][Wikipedia - YAGNI]
[KISS][Wikipedia - KISS]

[Test-driven Development][Wikipedia - TDD] helps minimize feedback loop so it's
easier to track down where a bug was introduced.

Build for change.

### [Empower the team][Wikipedia - Lean Empower The Team]

> Find good people and let them do their own job.  
[Wikipedia - Lean Empower The Team][Wikipedia - Lean Empower The Team]

> You don't send messages because you have objects, you have objects because you
> send messages.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

> When design is dictated from afar none of the necessary adjustments can occur
and early failures of understanding get cemented into the code.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

Applies to real teams, and also objects. Find the right object and let it do
it's job.

[Single Responsibility Principle][Wikipedia - SRP]
[SOLID][Wikipedia - SOLID]
[GRASP][Wikipedia - GRASP]
[High Cohesion][Wikipedia - GRASP - High Cohesion]

[MINASWAN][Wikipedia - MINASWAN]

### [Build quality in][Wikipedia - Lean Build Quality In]

> Conceptual integrity means that the system's separate components work together
> as a whole with balance between flexibility, maintainability, efficiency, and
> responsiveness.  
[Wikipedia - Build Quality In][Wikipedia - Lean Build Quality In]

> Repetitions in the code are signs of bad code design and should be avoided.  
[Wikipedia - Build Quality In][Wikipedia - Lean Build Quality In]

> Depend on things that change less often than you do.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

[DRY][Wikipedia - DRY]
[Refactoring]][Refactoring]
[TDD][Wikipedia - TDD] Again, feedback provided by TDD gives
you more immediate feedback on the quality of the design you have implemented.
[Pair programming][Wikipedia - Pair Programming]

### [See the whole][Wikipedia - Lean See The Whole]

> By decomposing the big tasks into smaller tasks ... the root cause of defects
> should be found and eliminated.  
[Wikipedia - See The Whole][Wikipedia - Lean See The Whole]

> The larger the system, the more organizations that are involved in its
> development and the more parts are developed by different teams, the greater the
> importance of having well defined relationships between different vendors, in
> order to produce a system with smoothly interacting components.  
[Wikipedia - See The Whole][Wikipedia - Lean See The Whole]

> Using dependency injection to shape code relies on your ability to recognize
> that the responsibility for knowing the name of a message to send to that
> class may belong to different objects.  
[Sandi Metz][SandiMetz] from [Practical Object-Oriented Development in Ruby][Amazon - POODR]

> Which class is responsible for creating objects is a fundamental property of
> the relationship between objects of particular classes.  
[General Responsibility Assignment Software Patterns (GRASP)][Wikipedia - GRASP]

[TDD][Wikipedia - TDD] Helps encourage a larger perspective by ensuring that all
objects have to interacting with at least one other class.
[Think big, act small][Lean Software Development - Think Big, Act Small]
[Refactoring][Refactoring]

[^1]: [SoftwareQuotes.com - GordonBell][SoftwareQuotes - Gordon Bell]
[^2]: [LisaCrispin.com - Shortening the Feedback Loop][Lisa Crispin - Quote]
[^3]: [books.google.com - Practical Object-Oriented Design in Ruby by Sandi Metz][GoogleBooks - POODR - Decide Later]
[^4]: [Giant Robots Smashing into Other Giant Robots Podcast - Episode 155 - CTO Duties][GiantRobots.fm - CTO Duties]

[Amazon - POODR]: http://www.amazon.com/gp/search?index=books&linkCode=qs&keywords=9780321721334 "Practical Object Oriented Design in Ruby: An Agile Primer by Sandi Metz"
[GiantRobots.fm - CTO Duties]: http://giantrobots.fm/155 "Giant Robots Smashing into Other Giant Robots Podcast - Episode 155 - CTO Duties"
[GoogleBooks - POODR - Decide Later]: https://books.google.com/books?id=VRCv_bATuSIC&lpg=PA32&dq=%22Any%20decision%20you%20make%20in%20advance%20of%20an%20explicit%20requirement%20is%20just%20a%20guess.%20Don't%20decide%3B%20preserve%20your%20ability%20to%20make%20a%20decision%20later.%22&pg=PA32#v=onepage&q=%22Any%20decision%20you%20make%20in%20advance%20of%20an%20explicit%20requirement%20is%20just%20a%20guess.%20Don't%20decide;%20preserve%20your%20ability%20to%20make%20a%20decision%20later.%22&f=false "books.google.com - Practical Object-Oriented Design in Ruby by Sandi Metz"
[Launch Academy Blog - Product Development Lifecycle]: http://blog.launchacademy.com/the-product-development-life-cycle/ "Launch Academy Blog | The Product Development Life Cycle"
[Lean Software Development - Think Big, Act Small]: https://books.google.com/books?id=hQk4S7asBi4C&lpg=PA182&ots=x6xONzjC87&dq=Think%20big%2C%20act%20small%2C%20fail%20fast%3B%20learn%20rapidly%20Lean&pg=PA182#v=onepage&q=%22Think%20big,%20act%20small,%20fail%20fast;%20learn%20rapidly%22&f=false "books.google.com - Lean Software Development - Think Big, Act Small"
[Lean Software Development - Fail Fast]: https://books.google.com/books?id=hQk4S7asBi4C&lpg=PA182&ots=x6xONzjC87&dq=Think%20big%2C%20act%20small%2C%20fail%20fast%3B%20learn%20rapidly%20Lean&pg=PA182#v=onepage&q=%22Think%20big,%20act%20small,%20fail%20fast;%20learn%20rapidly%22&f=false "books.google.com - Lean Software Development - Fail Fast; Learn rapidly"
[Lisa Crispin]: http://lisacrispin.com/ "LisaCrispin.com - Agile Testing with Lisa Crispin"
[Lisa Crispin - Quote]: http://lisacrispin.com/2011/03/20/shortening-the-feedback-loop/ "LisaCrispin.com - Agile Testing with Lisa Crispin - Shortening the Feedback Loop"
[SandiMetz]: http://www.sandimetz.com/ "SandiMetz.com"
[SoftwareQuotes - Gordon Bell]: http://www.softwarequotes.com/showquotes.aspx?id=813&name=Bell,Gordon#4809 "SoftwareQuotes.com - Gordon Bell"
[Thoughtbot - Joe Ferris]: https://thoughtbot.com/people#joe-ferris "Thoughtbot.com - Our Team - Joe Ferris"
[Wikipedia - Agile]: https://en.wikipedia.org/wiki/Agile_software_development "Wikipedia.org - Agile software development"
[Wikipedia - Agile - Agile Manifesto]: https://en.wikipedia.org/wiki/Agile_software_development#The_Agile_Manifesto "Wikipedia.org - Agile software development - The Agile Manifesto"
[Wikipedia - Dependency Injection]: https://en.wikipedia.org/wiki/Dependency_injection "Wikipedia.org - Dependency Injection"
[Wikipedia - Dependency Inversion Principle]: https://en.wikipedia.org/wiki/Dependency_inversion_principle "Wikipedia.org - Dependency Inversion Principle"
[Wikipedia - DRY]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself "Wikipedia.org - DRY"
[Wikipedia - Gordon Bell]: https://en.wikipedia.org/wiki/Gordon_Bell "Wikipedia.org - Gordon Bell"
[Wikipedia - GRASP]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design) "Wikipedia.org - GRASP (object-oriented design)"
[Wikipedia - GRASP - High Cohesion]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)#High_Cohesion "Wikipedia.org - GRASP - High cohesion"
[Wikipedia - GRASP - Low Coupling]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)#Low_Coupling "Wikipedia.org - GRASP - Low coupling"
[Wikipedia - GRASP - Creator]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)#Creator "Wikipedia.org - GRASP - Creator"
[Wikipedia - KISS]: https://en.wikipedia.org/wiki/KISS_principle "Wikipedia.org - KISS Principle"
[Wikipedia - Lean Software Development]: https://en.wikipedia.org/wiki/Lean_software_development "Wikipedia.org - Lean Software Development"
[Wikipedia - Lean Principles]: https://en.wikipedia.org/wiki/Lean_software_development#Lean_principles "Wikipedia.org - Lean Principles"
[Wikipedia - Lean Eliminate Waste]: https://en.wikipedia.org/wiki/Lean_software_development#Eliminate_waste "Wikipedia.org - Lean Software Development - Eliminate waste"
[Wikipedia - Lean Amplify Learning]: https://en.wikipedia.org/wiki/Lean_software_development#Amplify_learning "Wikipedia.org - Lean Software Development - Amplify learning"
[Wikipedia - Lean Empower The Team]: https://en.wikipedia.org/wiki/Lean_software_development#Empower_the_team "Wikipedia.org - Lean Software Development - Empower the team"
[Wikipedia - Lean Decide Late]: https://en.wikipedia.org/wiki/Lean_software_development#Decide_as_late_as_possible "Wikipedia.org - Lean Software Development - Decide as late as possible"
[Wikipedia - Lean Deliver Fast]: https://en.wikipedia.org/wiki/Lean_software_development#Deliver_as_fast_as_possible "Wikipedia.org - Lean Software Development - Deliver as fast as possible"
[Wikipedia - Lean See The Whole]: https://en.wikipedia.org/wiki/Lean_software_development#See_the_whole "Wikipedia.org - Lean Software Development - see The whole"
[Wikipedia - Lean Build Quality In]: https://en.wikipedia.org/wiki/Lean_software_development#Build_quality_in "Wikipedia.org - Lean Software Development - Build quality in"
[Wikipedia - Loose Coupling]: https://en.wikipedia.org/wiki/Loose_coupling "Wikipedia.org - Loose coupling"
[Wikipedia - MINASWAN]: https://en.wikipedia.org/wiki/MINASWAN "Wikipedia.org - MINASWAN"
[Wikipedia - Pair Programming]: https://en.wikipedia.org/wiki/Pair_programming " Wikipedia.org - Pair Programming"
[Refactoring]: http://www.refactoring.com/ "Refactoring.com"
[Wikipedia - SOLID]: https://en.wikipedia.org/wiki/SOLID_(object-oriented_design) "Wikipedia.org - SOLID (object-oriented design)"
[Wikipedia - SRP]: https://en.wikipedia.org/wiki/Single_responsibility_principle "Wikipedia.org - The Single Responsibility Principle"
[Wikipedia - TDD]: https://en.wikipedia.org/wiki/Test-driven_development "Wikipedia.org - Test-driven Development"
[Wikipedia - YAGNI]: https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it "Wikipedia.org - YAGNI"
