---
author: Danny Guinther
categories: [dev/bash, dev/git, dev/linux]
featured_image:
  alt_text: 60 Bash-tastic Git Aliases
  title: 60 Bash-tastic Git Aliases
  url: /assets/images/featured/2015-04-12-sixty-bash-tastic-git-aliases.jpg
layout: post
permalink: /60-bash-tastic-git-aliases
tags: [alias, aliases, bash, bash aliases, git, git aliases]
title: 60 Bash-tastic Git Aliases
---
After spending the last 3.5 years using [git](https://git-scm.herokuapp.com/)
for version control, I can't imagine going back to a life without it. I
won't even start with the plethora of reasons why you should use a [source control
management (SCM)](https://en.wikipedia.org/wiki/Revision_control) tool like
git, but if you don't, suffice it to say that you should start **right now**.

Though much of the focus on git is related to its benefits as an SCM, as
I've gotten more comfortable with git, I've found it to be an invaluable
swiss army knife for general development. So much so that 15 of the 25 most used
commands in my **bash** history on my personal laptop are git commands. On my
work laptop git commands take up 17 of the top 25 commands!

There's more to git than just source control. If you're unfamiliar with git or
have just enough of an understanding to get by, I encourage you to take the time
to really dig into git and figure out how you can leverage its awesomeness to
improve your development process. After spending a little time with git, I'd be
surprised if most developers don't come away with improvements in productivity,
reliability, consistency, and even creativity.

As I've used git more, I've found it helpful to create bash aliases for some
of the commands I most frequently use. Though it is possible to add aliases
directly to git, I prefer to add aliases to bash because I'm more familiar
with bash and because aliasing git commands from bash allows me to save a few
extra characters on my most frequently used git commands.

These aliases reflect my workflow and how I tend to do things, so some of these
aliases may not be appropriate for everyone. As such, if you find aliases here
that you like, I encourage you to familiarize yourself with a few at a time,
rather than adding all of these aliases to your **.bash_aliases** at once. As
I'm sure has been said about many flavors of Linux config file, .bash_aliases is
like a Jedi's lightsaber, in that every Jedi must build their own.

On with the aliases!

***

## Basics

#### **gcl**: git clone

This alias is a wrapper around your standard **git clone** command.

Though this is one of my less frequently used aliases, I think it's worthwhile
to have, even if you don't use it everyday.

**Alias:**

```{"language": "bash", "gutter": false}
alias gcl='git clone'
```

**Mnemonic:**

- **g**it **cl**one

**Example:**

```{"language": "text", "gutter": false}
$ gcl git@github.com:pry/pry.git
Cloning into 'pry'...
remote: Counting objects: 23957, done.
remote: Total 23957 (delta 0), reused 0 (delta 0), pack-reused 23957
Receiving objects: 100% (23957/23957), 7.89 MiB | 852.00 KiB/s, done.
Resolving deltas: 100% (12168/12168), done.
Checking connectivity... done.
```

***

#### **gget and gput**: git pull and git push

Since *push* and *pull* have a lot of character overlap and neither offers a
particularly clear 4-letter alias, I prefer to use verb descriptors for
both. The chosen verbs are short and correlate to similar HTTP request verbs
which helps with remembering which is which.

**Alias:**

```{"language": "bash", "gutter": false}
alias gget='git pull'
alias gput='git push'
```

**Mnemonic:**

- Similar to HTTP verbs
- **g**it ~~pull~~ **get**
- **g**it ~~push~~ **put**

**Example:**

```{"language": "text", "gutter": false}
$ gget
Current branch master is up to date.
$ gput
Counting objects: 17, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (7/7), 643 bytes | 0 bytes/s, done.
Total 7 (delta 4), reused 0 (delta 0)
To git@github.com:tdg5/some_repo.git
   9ac23ef..7bacf33  master -> master
```

***

#### **gs**: git status

I may be guilty of over using **git status**, seeing as it's always at the top
of the list of my most frequently used commands. That said, when navigating
between repos or staging changes for a commit, **git status** is enormously
useful for getting a handle on the present state of a git repository.

Tip: If you find yourself running **git status** a lot, a prompt that reflects
the status of the current git repository like
[liquidprompt](https://github.com/nojhan/liquidprompt) might help.

Warning: **gs** is also the name of the name of the Ghostscript binary. If you
frequently use Ghostscript, you will want to use a different alias for **git
status**.

**Alias:**

```{"language": "bash", "gutter": false}
alias gs='git status'
```

**Mnemonic:**

- **g**it **s**tatus

**Example:**

```{"language": "text", "gutter": false}
$ gs
On branch master
Your branch is up-to-date with 'origin/master'.

nothing to commit, working directory clean
```

***

#### **gsh**: git show

Useful for looking at various kinds of objects. I mostly use it to view
the previous commit in the tree. **git show** is particularly handy when
applying amendments or rebasing interactively.

**Alias:**

```{"language": "bash", "gutter": false}
alias gsh='git show'
```

**Mnemonic:**

- **g**it **sh**ow

**Example:**

```{"language": "text", "gutter": false}
$ gsh
commit d316dce7e8446a7381d9d1e7198f96edb29952b5
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Sun Apr 5 09:48:53 2015 -0400

    Include empty app/models/concerns directory

diff --git a/app/models/concerns/.gitkeep b/app/models/concerns/.gitkeep
new file mode 100644
index 0000000..e69de29
```

***

#### **gshn**: git show HEAD@{n}

Useful when you want to view the nth previous HEAD reference. HEAD references
don't always line up with commits so this can be useful in situations where you
want to view a particular amendment or want something more granular than what's
provided by **git log -p**.

**Function:**

```{"language": "bash", "gutter": false}
function gshn() {
  ([ -z "$1" ] || [ $(($1)) -lt 0 ]) && echo 'Invalid integer!' && return
  git show HEAD@{$1}
}
```

**Mnemonic:**

- **g**it **sh**ow HEAD@{**n**}

**Example:**

```{"language": "text", "gutter": false}
$ gshn 1
commit d316dce7e8446a7381d9d1e7198f96edb29952b5
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Sun Apr 5 09:48:53 2015 -0400

    Include empty app/tasks directory

diff --git a/app/tasks/.gitkeep b/app/tasks/.gitkeep
new file mode 100644
index 0000000..e69de29
```

***

## Branch shenanigans

#### **gbr**: git branch

Your most basic **git branch** command. Returns a list of local branches when
no arguments are given. Otherwise, expands to support all the goodness of the
full **git branch** command.

**Alias:**

```{"language": "bash", "gutter": false}
alias gbr='git branch'
```

**Mnemonic:**

- **g**it **br**anch

**Example:**

```{"language": "text", "gutter": false}
$ gbr
* master
  dev
  WIP
```

***

#### **gbrc**: git branch current

Utility function for retrieving the name of the current branch. Useful with
other commands when invoked from a sub-shell.

**Alias:**

```{"language": "bash", "gutter": false}
alias gbrc='git rev-parse --abbrev-ref HEAD'
```

**Mnemonic:**

- **g**it **br**anch **c**urrent

**Example:**

```{"language": "text", "gutter": false}
git checkout -b long_branch_name
git push -u origin $(gbrc)
Total 0 (delta 0), reused 0 (delta 0)
To git@github.com:tdg5/some_repo.git
 * [new branch]      long_branch_name -> long_branch_name
Branch long_branch_name set up to track remote branch long_branch_name from origin by rebasing.
```

***

#### **gbrp**: git branch previous

Utility function for retrieving the name of the previous branch that was checked
out. Particularly useful when used with other commands and it's invoked from a
sub-shell.

**Alias:**

```{"language": "bash", "gutter": false}
alias gbrp='git reflog | sed -n "s/.*checkout: moving from .* to \(.*\)/\1/p" | sed "2q;d"'
```

**Mnemonic:**

- **g**it **br**anch **p**revious

**Example:**

```{"language": "text", "gutter": false}
git rebase $(gbrp)
First, rewinding head to replay your work on top of it...
Fast-forwarded master to long_branch_name.
```

***

#### **gbrb**: git branch back

Helper shortcut for returning to the previous branch that was checked out. For
example if you switch from your master branch to a development branch, **gbrb**
would take you back to master.

**Alias:**

```{"language": "bash", "gutter": false}
alias gbrb="git checkout -"
```

**Mnemonic:**

- **g**it **br**anch **b**ack
- **g**it **b**e **r**ight **b**ack
- **g**it **brb**

**Example:**

```{"language": "text", "gutter": false}
$ git checkout master
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.
$ gbrb
Switched to branch 'dev'
Your branch is up-to-date with 'origin/dev'.
```

***

#### **gbrr**: git branch recent

This function is useful for situations in which you want to return to a branch
you recently checked out, but don't remember the name of the branch. Running
this command will list the last 10 branches that were checked out for the
current repo and prompt you to select which of those branches to checkout. If
the last 10 branches isn't enough, the command can be configured to show more.

I don't remember exactly where I found this function, but it seems to be an
adaptation of the work of [Nathan
Reynolds](git@github.com:nathforge/git-branch-recent.git).

**Function:**

```{"language": "bash", "gutter": false}
GBRR_DEFAULT_COUNT=10
function gbrr() {
  COUNT=${1-$GBRR_DEFAULT_COUNT}

  IFS=$'\r\n' BRANCHES=($(
    git reflog | \
    sed -n 's/.*checkout: moving from .* to \(.*\)/\1/p' | \
    perl -ne 'print unless $a{$_}++' | \
    head -n $COUNT
  ))

  for ((i = 0; i < ${#BRANCHES[@]}; i++)); do
    echo "$i) ${BRANCHES[$i]}"
  done

  read -p "Switch to which branch? "
  if [[ $REPLY != "" ]] && [[ ${BRANCHES[$REPLY]} != "" ]]; then
    echo
    git checkout ${BRANCHES[$REPLY]}
  else
    echo Aborted.
  fi
}
```

**Mnemonic:**

- **g**it **br**anch **r**ecent

**Example:**

```{"language": "text", "gutter": false}
$ gbrr
0) master
1) before_merge
2) error_detect_redux
3) d19d281e8737d02432d6e89f7b92b4238b2f2776
4) console_commands
5) pyramid_of_doom
6) disable_personal_backup
7) expect_instances
8) fix_read_consistency
9) s3_wip
Switch to which branch? 5

Switched to branch 'pyramid_of_doom'
Your branch is up-to-date with 'origin/pyramid_of_doom'.
```

***

## Stash shortcuts

#### **gst**: git stash

Most of my **git stash** aliases share a prefix of **gs**, however since **gs**
is already reserved by **git status**, I use **gst** as an alias for the vanilla
**git stash** command. Given the other aliases I have for **git stash**, I don't
use this alias that often, but it's occasionally convenient to have it around.

**Alias:**

```{"language": "bash", "gutter": false}
alias gst='git stash'
```

**Mnemonic:**

- **g**it **st**ash
- **g**it **s**tash **t**ypical

**Example:**

```{"language": "text", "gutter": false}
$ gst
Saved working directory and index state WIP on master: 7bacf33 Add git merge related bash aliases
HEAD is now at 7bacf33 Add git merge related bash aliases
```

#### **gss**: git stash save

Saves local changes to a new stash. Unlike **git stash** also optionally takes
a message describing the contents of the stash. I find adding a message to
stashed items much, much more useful than the information that is used by
default if you don't provide a message.

**Alias:**

```{"language": "bash", "gutter": false}
alias gss='git stash save'
```

**Mnemonic:**

- **g**it **s**tash **s**ave

**Example:**

```{"language": "text", "gutter": false}
$ gss "Minor refactoring of user model"
Saved working directory and index state On master: Minor refactoring of user model
HEAD is now at 62758b7 Add tests for user model
```

***

#### **gsa**: git stash apply

Short-hand for the **git stash apply** command. Without additional arguments,
applies the stashed state at the top of the stash to the working tree without
removing the applied stash. Can also be used with **stash@{n}** to reference a
particular item in the stash.

**Alias:**

```{"language": "bash", "gutter": false}
alias gsa='git stash apply'
```

**Mnemonic:**

- **g**it **s**tash **a**pply

**Example:**

```{"language": "text", "gutter": false}
$ gsa stash@{1}
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   stashed_file
```

***

#### **gsl**: git stash list

Lists all items in the local stash.

**Alias:**

```{"language": "bash", "gutter": false}
alias gsl='git stash list'
```

**Mnemonic:**

- **g**it **s**tash **l**ist

**Example:**

```{"language": "text", "gutter": false}
$ gsl
stash@{0}: WIP on master: 21e072b Ignore generated src.html in project root
stash@{1}: On master: e80ea55 Run test suite in parallel
```

***

#### **gsp**: git stash pop

Without additional arguments it removes the stashed state from the top of the
stash stack and apples it to the working tree. Can also be used with
**stash@{n}** to reference a particular item in the stash.

**Alias:**

```{"language": "bash", "gutter": false}
alias gsp='git stash pop'
```

**Mnemonic:**

- **g**it **s**tash **p**op

**Example:**

```{"language": "text", "gutter": false}
$ gsp
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   stashed_file

Dropped refs/stash@{0} (394f8cccb3416aa85117a9a187de1f0003dac69a)
```

***

#### **gssh**: git stash show

Shows the changes recorded in the stash as a diff between the stashed state and
its original parent. By default shows the stash at the top of the stack, but can
be used with **stash@{n}** to show a particular item in the stash. This command
is very handy for those situations where you're trying to find something lost in
the stash.

I use the **-p** option with this alias to make it more like **git show**.

**Alias:**

```{"language": "bash", "gutter": false}
alias gssh='git stash show -p'
```

**Mnemonic:**

- **g**it **s**tash **sh**ow

**Example:**

```{"language": "text", "gutter": false}
$ gssh
diff --git a/stashed_file b/stashed_file
new file mode 100644
index 0000000..e69de29
```

***

#### **gsshno**: git stash show name-only

Similar to the **gssh** alias, but only outputs the names of modified files
rather than the full diff of the modified files. Useful in conjunction with
other command-line utilities that take a list of files such as **grep**.

**Alias:**

```{"language": "bash", "gutter": false}
alias gssh='git stash show --name-only'
```

**Mnemonic:**

- **g**it **s**tash **sh**ow

**Example:**

```{"language": "text", "gutter": false}
$ gssh
diff --git a/stashed_file b/stashed_file
new file mode 100644
index 0000000..e69de29
```

***

#### **gsd**: git stash drop

Remove a single stashed state from the stash stack. By default, removes the
latest stash, but other stashes can be targeted using a stash log
reference of the form **stash@{n}**.

This alias is handy when it comes time to clean up an overgrown stash.

**Alias:**

```{"language": "bash", "gutter": false}
alias gsd='git stash drop'
```

**Mnemonic:**

- **g**it **s**tash **d**rop

**Example:**

```{"language": "text", "gutter": false}
$ gsd stash@{1}
Dropped refs/stash@{1} (394f8cccb3416aa85117a9a187de1f0003dac69a)
```

***

## Grepping around

#### **gg**: git grep

This alias is a shorthand for the vanilla **git grep** command.

I was recently shocked to learn that one of my co-workers just recently
discovered git's built in grep command. I was surprised because I feel like
**git grep** is one of those commands I would have trouble coding without. As
such I have a number of different aliases for invoking **git grep** with a
variety of different options.

I haven't tried it yet, but I have at times considered extending my default
**gg** alias to include the **-E** option to enable use of **e**xtended regular
expressions. More often than not, a simple **git grep** does the trick, so I
haven't felt the need to incorporate the **-E** option.

**Alias:**

```{"language": "bash", "gutter": false}
alias gg='git grep'
```

**Mnemonic:**

- **g**it **g**rep

**Example:**

```{"language": "text", "gutter": false}
$ gg Rails
config.ru:run Rails.application
config/application.rb:Bundler.require(:default, Rails.env)
config/application.rb:  class Application < Rails::Application
config/application.rb:    config.autoload_paths << Rails.root.join('lib').to_s
config/boot.rb:module Rails
```

***

#### **ggi**: git grep case-insensitive

This alternate alias for **git grep** is frequently useful in situations where
the case of the search string cannot be depended on. For example, since, for
better or worse, many devs have a habit of naming variables after the class of
the object, using a case-insensitive search can be useful for finding places
where a class is used that might not refer to the class directly.

**Alias:**

```{"language": "bash", "gutter": false}
alias ggi='git grep -i'
```

**Mnemonic:**

- **g**it **g**rep case-**i**nsensitive

**Example:**

```{"language": "text", "gutter": false}
$ ggi Rails
Gemfile:gem 'rails', '~> 4.1.0'
Gemfile:  gem 'factory_girl_rails'
Gemfile:    gem 'pry-rails'
Gemfile.lock:  pry-rails
Gemfile.lock:  rails (~> 4.1.0)
bin/rails:require 'rails/commands'
config.ru:run Rails.application
config/application.rb:require 'rails/all'
config/application.rb:Bundler.require(:default, Rails.env)
```

***

#### **ggno**: git grep name-only

This alias for **git grep** is handy in situations where you're mainly
interested in which files contain the given search string, but have less concern
for how that string appears in the file.

I'm not sure of the utility of this alias these days as in the past I mainly
used it to open all files containing a particular string in my editor. I suppose
it's handy when you're trying to get a feel for how often a string appears
without getting into the details of the context the string appears in.

**Alias:**

```{"language": "bash", "gutter": false}
alias ggno='git grep --name-only'
```

**Mnemonic:**

- **g**it **g**rep **n**ame-**o**nly

**Example:**

```{"language": "text", "gutter": false}
$ ggno Rails
config.ru
config/application.rb
config/boot.rb
config/environment.rb
config/environments/development.rb
config/environments/production.rb
config/environments/test.rb
```

***

#### **ggo**: git grep open

Passes the resulting file names of a **git grep --name-only** to the default
$EDITOR. Useful when I want to open every file that contains a particular search
string. Requires that the **$EDITOR** environment variable is set.

This alias uses the **$@** bash variable to grab all of the arguments to the
alias and pass them along to the inner **git grep** command.

Should probably be modified so it doesn't open the $EDITOR when no results are
found, but this hasn't been an issue for me.

**Alias:**

```{"language": "bash", "gutter": false}
function ggo() {
  $EDITOR $(git grep --name-only "$@")
}
```

**Mnemonic:**

- **g**it **g**rep **o**pen

**Example:**

```{"language": "text", "gutter": false}
# For my setup, opens a VIM session with every file that contains the word
# Rails.
$ ggo Rails
```

***

#### **ggio**: git grep case-insensitive open

Similar to **ggi**, useful in situations where you want to use the default
$EDITOR to view every file that contains a case-insensitive version of the search
string. Requires that the **$EDITOR** environment variable is set. This alias
uses **$@** to pass any arguments on to the underlying **git grep** command.

**Alias:**

```{"language": "bash", "gutter": false}
function ggio() {
  $EDITOR $(git grep -i --name-only "$@")
}
```

**Mnemonic:**

- **g**it **g**rep case-**i**nsensitive **o**pen
- **ggio** instead of **ggoi** because of order of operations. First the
  case-**i**nsensitive **git grep**, then the **o**pen.

**Example:**

```{"language": "text", "gutter": false}
# For my setup, opens a VIM session with every file that contains a
# case-insensitive version of the word Rails.
$ ggio Rails
```

***

## Rebase basics

#### **grb**: git rebase

Forward-port local commits to the updated upstream head.

I tend to use a rebase heavy workflow, so having many aliases for **git rebase**
is pretty useful to me. If you don't use **git rebase** that often, these
aliases might not be of particular utility.

This alias is a shorthand for the basic **git rebase** command.

**Alias:**

```{"language": "bash", "gutter": false}
alias grb='git rebase'
```

**Mnemonic:**

- **g**it **r**e**b**ase

**Example:**

```{"language": "text", "gutter": false}
$ grb master
First, rewinding head to replay your work on top of it...
Fast-forwarded dev to master.
```

***

#### **grbi**: git rebase interactive

Makes a list of the commits which are about to be rebased and lets the user edit
that list before rebasing.

Interactive rebasing is outside the scope of this article, but it's a
tremendously useful tool for making various changes and amendments to previous
commits in your working tree. If you're not comfortable with interactive rebasing,
I encourage you to learn more about the process.

**Alias:**

```{"language": "bash", "gutter": false}
alias grbi='git rebase --interactive'
```

**Mnemonic:**

- **g**it **r**e**b**ase **i**nteractive

**Example:**

```{"language": "text", "gutter": false}
# In my setup, opens a VIM session with a list of the commits that are # going
# to be rebased and allows me to select what actions to take on each of # those
# commits.
$ grbi HEAD~~~
```

***

#### **grba**: git rebase abort

Cancels the active rebase.

Handy in those occasional situations where a rebase is going horribly wrong. I
don't tend to use this alias very often, but it's nice to have aliases for all
of the common rebase actions.

**Alias:**

```{"language": "bash", "gutter": false}
alias grba='git rebase --abort'
```

**Mnemonic:**

- **g**it **r**e**b**ase **a**bort

**Example:**

```{"language": "text", "gutter": false}
# No message is displayed when aborting a rebase.
$ grba
```

***

#### **grbc**: git rebase continue

Continues the active rebase.

A handy helper in situations where I'm interactively rebasing and I've finished
modifying one commit and I'm ready to move on to the next commit that needs
modification. Also useful after resolving merge conflicts.

**Alias:**

```{"language": "bash", "gutter": false}
alias grbc='git rebase --continue'
```

**Mnemonic:**

- **g**it **r**e**b**ase **c**ontinue

**Example:**

```{"language": "text", "gutter": false}
$ grbc
Stopped at bda4f7035b8f9db1f2dd42a316e2ccb2da8b0955... Add test harness
You can amend the commit now, with

        git commit --amend

Once you are satisfied with your changes, run

        git rebase --continue
```

***

#### **grbs**: git rebase skip

Skips a commit during a rebase operation.

Useful in rare situations where I've modified earlier commits such that a later
commit is no longer needed and appears to be empty. In these situations, **git
rebase --skip** is useful to ignore those commits and continue the rebase
without them.

**Alias:**

```{"language": "bash", "gutter": false}
alias grbs='git rebase --skip'
```

**Mnemonic:**

- **g**it **r**e**b**ase **s**kip

**Example:**

```{"language": "text", "gutter": false}
```

***

#### **grbp**: git rebase previous

Rebases the current branch from the previous branch that was checked out.

Useful in situations where you've been working on a branch and it's time to
rebase that branch onto master. This command could probably benefit from passing
along additional arguments using **$@**, but I haven't yet found a need to do
so.

I think this could be done as an alias rather than as a function, but I think
the functional form is more readable than jamming it all into an alias. YMMV.

**Function:**

```{"language": "bash", "gutter": false}
# Rebase from previous branch
function grbp() {
  br="$(git reflog | sed -n 's/.*checkout: moving from .* to \(.*\)/\1/p' | sed "2q;d")"
  git rebase $br
}
```

**Mnemonic:**

- **g**it **r**e**b**ase from **p**revious branch

**Example:**

```{"language": "text", "gutter": false}
$ grbp
First, rewinding head to replay your work on top of it...
Fast-forwarded master to dev.
```

***

#### **grbm**: git rebase master

Rebases the current branch from master.

Rebasing from master happens often enough that it's useful to have an alias
dedicated to just that.

**Alias:**

```{"language": "bash", "gutter": false}
# Rebase from previous branch
alias grbm='git rebase master'
```

**Mnemonic:**

- **g**it **r**e**b**ase from **m**aster branch

**Example:**

```{"language": "text", "gutter": false}
$ grbm
First, rewinding head to replay your work on top of it...
Fast-forwarded dev to master.
```

***

## Merging a cherry-pick often ends with amended commits

#### **gcm**: git commit

Alias for the standard **git commit** command. For a long time, I had this alias
invoke **git commit -m** to allow for adding a message from the command-line,
however, I recently switched it to **git commit** instead to encourage myself to
use my **$EDITOR** for adding commit messages. YMMV.

**Alias:**

```{"language": "bash", "gutter": false}
alias gcm='git commit'
```

**Mnemonic:**

- **g**it **c**o**m**mit

**Example:**

```{"language": "text", "gutter": false}
# On my setup this opens VIM where I can enter my commit message. The following
# is displayed after entering my commit message and exiting VIM.
$ gcm
[master 58a3a17] Refactor User ACL logic.
 1 file changed, 17 insertion(+), 11 deletion(-)
```

***

#### **gcmm**: git commit message

Though I've tried to switch to using my editor for entering commit messages in
most cases, it is still occasionally useful to have an alias that allows for
entering a commit message from the command-line.

**Alias:**

```{"language": "bash", "gutter": false}
alias gcmm='git commit -m'
```

**Mnemonic:**

- **g**it **c**o**m**mit with **m**essage

**Example:**

```{"language": "text", "gutter": false}
$ gcmm "Add regression test for user auth bug."
[master 61a5220] Add regression test for user auth bug.
 1 file changed, 32 insertion(+), 7 deletion(-)
```

***

#### **gcp**: git cherry-pick

Though it can lead to weirdness with later **git merge** or **git rebase**
operations, **git cherry-pick** can be a pretty useful tool in situations where
I want to grab only a handful of commits from one branch and apply them to
another.

I also find it useful in situations where I decide it would make more
sense if the history of the branch I'm working on played out in a different
order. When this happens, I will checkout a new branch and cherry-pick the
commits I want from the old branch to the new branch in whatever order is
preferred.

**Alias:**

```{"language": "bash", "gutter": false}
alias gcp='git cherry-pick'
```

**Mnemonic:**

- **g**it **c**herry-**p**ick

**Example:**

```{"language": "text", "gutter": false}
$ gcp 06b12b8464725ec7b2c8d618a95f8b46c95b9f59
[master f77f027] Add .gitkeep placeholder to config directory.
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 config/.gitkeep
```

***

#### **gamd**: git amend without edit

Maybe it's a sign that my workflow is too often interrupted by context switches,
but I often encounter situations where code that logically belongs with the
previous commit turns up after I've already made the commit. Luckily, **git
commit --amend** makes it easy to add to the previous commit without having to
reset the commit and commit it anew.

Of the aliases I have for **git commit --amend** this tends to be my most
frequently used alias even though it is a more specialized amend action. I don't
have a strong opinion on the matter, but I feel like an amendment that requires
changing the commit message should be regarded suspiciously as it may be an
indication that the previous commit is taking on additional responsibilities
that may make more sense in a new commit.

That said, if you're intention is just to change the commit message, the next
alias, **gamend** is what you are looking for.

**Alias:**

```{"language": "bash", "gutter": false}
alias gamd='git commit --amend --no-edit'
```

**Mnemonic:**

- **g**it **a**men**d** commit without editing message
- Shorter command goes with shorter amend action (no message change required)

**Example:**

```{"language": "text", "gutter": false}
$ gamd
[master 7bacf33] Add user tests
 1 file changed, 9 insertions(+)
```

***

#### **gamend**: git commit with message edit

The more mutative cousin of **gamd**, **gamend** aliases **git commit --amend**
without any additional arguments. By default, this will add any staged changes
to the previous commit and open your editor so that you may change the previous
commit message.

**Alias:**

```{"language": "bash", "gutter": false}
alias gamend='git commit --amend'
```

**Mnemonic:**

- **g**it **amend** commit and edit message
- Longer command goes with longer amend action (message change possible)

**Example:**

```{"language": "text", "gutter": false}
# On my setup, this command opens VIM allowing me to change the commit message
# of the previous commit. The following output is displayed after exiting VIM.
$ gamend
[master 7bacf33] Add user auth tests
 1 file changed, 9 insertions(+)
```

***

#### **gm**: git merge

Before we get into my **git merge** aliases, I should warn you that I don't use
**git merge** as much as I should. I'm trying to incorporate it more into my
workflow, hence the aliases, but given my relative inexperience with **git
merge**, these may not be the most astounding aliases.

The **gm** alias is a shorthand for the vanilla **git merge** command.

**Alias:**

```{"language": "bash", "gutter": false}
alias gm='git merge'
```

**Mnemonic:**

- **g**it **m**erge

**Example:**

```{"language": "text", "gutter": false}
$ gm master
Updating 6b0d6e5..d5dce5f
Fast-forward
 config/.gitkeep        |    0
 test/unit/user_test.rb |   22 ++++++++++++++++++++++++++
 app/models/user.rb     |    2 +-
 3 files changed, 1808 insertions(+), 1 deletion(-)
 create mode 100644 config/.gitkeep
```

***

#### **gmm**: git merge master

Since I find that merging the master branch into the current branch tends to be
among the most common **git merge** actions, the **gmm** alias does exactly
that.

**Alias:**

```{"language": "bash", "gutter": false}
alias gmm='git merge master'
```

**Mnemonic:**

- **g**it **m**erge **m**aster

**Example:**

```{"language": "text", "gutter": false}
$ gmm
Updating 6b0d6e5..d5dce5f
Fast-forward
 config/.gitkeep        |    0
 test/unit/user_test.rb |   22 ++++++++++++++++++++++++++
 app/models/user.rb     |    2 +-
 3 files changed, 1808 insertions(+), 1 deletion(-)
 create mode 100644 config/.gitkeep
```

***

#### **gmp**: git merge previous branch

Often if the branch being merged is not master, then it is usually the branch
that was previously checked out. This alias saves a few keystrokes and provides
a convenient way to merge the previously checked out branch into the current
branch.

YMMV, but I find the multi-line, functional form of this command to be more
readable than trying to fit the whole alias into a single line.

**Function:**

```{"language": "bash", "gutter": false}
function gmp() {
  br="$(git reflog | sed -n 's/.*checkout: moving from .* to \(.*\)/\1/p' | sed "2q;d")"
  git merge $br
}
```

**Mnemonic:**

- **g**it **m**erge **p**revious branch

**Example:**

```{"language": "text", "gutter": false}
$ gmp
Updating 6b0d6e5..d5dce5f
Fast-forward
 config/.gitkeep        |    0
 test/unit/user_test.rb |   22 ++++++++++++++++++++++++++
 app/models/user.rb     |    2 +-
 3 files changed, 1808 insertions(+), 1 deletion(-)
 create mode 100644 config/.gitkeep
```

***

## Add-itions

#### **ga**: git add

This alias provides a shorthand for the basic **git add** command. After **git
status** various flavors of **git add** are my next most commonly used git
commands.

**Alias:**

```{"language": "bash", "gutter": false}
alias ga='git add'
```

**Mnemonic:**

- **g**it **a**dd

**Example:**

```{"language": "text", "gutter": false}
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        other_unstaged_file
        unstaged_file

nothing added to commit but untracked files present (use "git add" to track)
$ ga unstaged_file
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   unstaged_file

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        other_unstaged_file
```

***

#### **gaa**: git add all

I tend to use this alias more often than the vanilla **git add** alias. The
difference is the addition of the **-A** argument which updates the index not
only where the working tree has a file matching the glob pattern but also where
the index already has an entry. This adds, modifies, and removes index entries
to match the working tree.

I haven't had many situations where I've accidentally committed changes that I
didn't mean to, but that is certainly something to watch out for when using this
alias.

**Alias:**

```{"language": "bash", "gutter": false}
alias gaa='git add -A'
```

**Mnemonic:**

- **g**it **a**dd **a**ll

**Example:**

```{"language": "text", "gutter": false}
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        other_unstaged_file
        unstaged_file

nothing added to commit but untracked files present (use "git add" to track)
$ gaa
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   unstaged_file
        new file:   other_unstaged_file
```

***

#### **gap**: git add patch

If you aren't familiar with the **git add -p** command, it is definitely another
command that I highly recommend you familiarize yourself with. The patch mode
for **git add** makes it easy to interactively select which changes to stage and
can be quite helpful when it comes to staging only parts of a modified file.

**Alias:**

```{"language": "bash", "gutter": false}
alias gap='git add -p'
```

**Mnemonic:**

- **g**it **a**dd **p**atch

**Example:**

```{"language": "text", "gutter": false}
$ gap
diff --git a/LICENSE b/LICENSE
index 93cf6cc..8ad58ca 100644
--- a/LICENSE
+++ b/LICENSE
@@ -1,4 +1,4 @@
-Copyright 2014 Danny Guinther
+Copyright 2015 Danny Guinther

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
Stage this hunk [y,n,q,a,d,/,e,?]? y
```

***

#### **gau**: git add update

I find this alias most helpful when I need to stage files that have been removed
from the work tree. This alias includes the **-u** option to **git add** which
updates the index only where it already has an entry matching the glob path.
This removes as well as modifies index entries to match the working tree, but
adds no new files.

**Alias:**

```{"language": "bash", "gutter": false}
alias gau='git add -u'
```

**Mnemonic:**

- **g**it **a**dd **u**pdate

**Example:**

```{"language": "text", "gutter": false}
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   modified_file

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   modified_file

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        unstaged_file

$ gau
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   modified_file

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        unstaged_file
```

***

## Reliable resets

#### **grh**: git reset HEAD

This alias invokes the **git reset HEAD** command which can be thought of as the
opposite of **git add**. This alias resets the index entries for all files
matching a glob pattern or relative to the current path. In simpler terms, this
alias can be used to unstage files that have been staged erroneously.

**Alias:**

```{"language": "bash", "gutter": false}
alias grh='git reset HEAD'
```

**Mnemonic:**

- **g**it **r**eset **h**ead

**Example:**

```{"language": "text", "gutter": false}
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   should_be_staged
        new file:   should_not_be_staged

$ grh should_not_be_staged
# No message is shown when resetting the working tree
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   should_be_staged

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        should_not_be_staged

```

***

#### **gback**: soft git reset HEAD~

This alias is a handy shorthand for doing a soft reset of the last commit. A
soft reset does not touch the index file nor the working tree at all, it only
resets the head to the given commit (in this case the last commit).

This alias is convenient in situations where I decide it makes more sense to
nuke the last commit and move in a different direction with the commit history
of my working tree.

I hope it goes without saying that this is not a command that should be used on
commits already added to the origin. This command is for restructuring new
commits that haven't yet been pushed to the origin.

**Alias:**

```{"language": "bash", "gutter": false}
alias gback='git reset --soft HEAD~'
```

**Mnemonic:**

- **g**it **back** to pre-commit state

**Example:**

```{"language": "text", "gutter": false}
$ git show
commit 9908c29d4c12ac7ef53dfeb571b5aeea1a6dde84
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 07:45:46 2015 -0400

    Add new file

diff --git a/new_file b/new_file
new file mode 100644
index 0000000..e69de29
$ gback
# No message is shown when resetting the working tree
$ git show
commit f755beeb8dc589ca81b8dca5dc6ef90d73d9f7c8
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 07:25:18 2015 -0400

    Add old file

diff --git a/old_file b/old_file
new file mode 100644
index 0000000..9ad63ea
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   new_file
```

***

#### **gbackk**: hard reset last commit

This alias is similar to the **gback** alias, except that it does a hard reset
of the index and working tree. Any changes to tracked files in the working tree
since the last commit will be discarded.

Take care when using this command as it can be easy to forget that the last
commit **and any uncommitted changes** since that commit **will be discarded**.

**Alias:**

```{"language": "bash", "gutter": false}
alias gbackk='git reset HEAD~ --hard'
```

**Mnemonic:**

- **g**it **back** to pre-commit state, **k**ill changes

**Example:**

```{"language": "text", "gutter": false}
$ git show
commit 9908c29d4c12ac7ef53dfeb571b5aeea1a6dde84
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 07:45:46 2015 -0400

    Add new file

diff --git a/new_file b/new_file
new file mode 100644
index 0000000..e69de29
$ gbackk
# No message is shown when resetting the working tree
$ git show
commit f755beeb8dc589ca81b8dca5dc6ef90d73d9f7c8
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 07:25:18 2015 -0400

    Add old file

diff --git a/old_file b/old_file
new file mode 100644
index 0000000..9ad63ea
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

nothing to commit, working directory clean
```

***

## Checkout

#### **gco**: git checkout

This alias is a shorthand for the basic **git checkout** command. **git
checkout** has two enormously useful purposes. Most commonly, **git checkout**
allows you to checkout a branch. Less commonly, **git checkout** can be used to
checkout files/paths to the working tree from HEAD, another branch, or a commit.

**Alias:**

```{"language": "bash", "gutter": false}
alias gco='git checkout'
```

**Mnemonic:**

- **g**it **c**heck**o**ut

**Example:**

```{"language": "text", "gutter": false}
# Checkout a branch
$ gco dev
Switched to branch 'dev'

# Checkout a file
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   modified_file

no changes added to commit (use "git add" and/or "git commit -a")
$ git checkout modified_file
# No output is shown when a file is checked out
$ git status
On branch master
nothing to commit, working directory clean
```

***

#### **gcoa**: git checkout all

This alias has yet to work its way into my muscle memory, but it's meant to be a
shorthand for checking out changes to all unstaged files in the current working
tree.

**Alias:**

```{"language": "bash", "gutter": false}
alias gcoa='git checkout .'
```

**Mnemonic:**

- **g**it **c**heck**o**ut **a**ll

**Example:**

```{"language": "text", "gutter": false}
$ git status
On branch masterr
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   new_file

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   modified_file

$ gcoa
# No output is shown when checking out the working tree.
$ git status
On branch masterr
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   new_file
```

***

#### **gcob**: git checkout branch

This alias provides a quick means of creating a new branch from the current HEAD
or a given starting reference and then checking out the new branch.

Though it's possible to create a new branch using the **git branch** command, I
rarely come across a situation where I want to create a branch, but don't want
to checkout that branch immediately.

**Alias:**

```{"language": "bash", "gutter": false}
alias gcob='git checkout -b'
```

**Mnemonic:**

- **g**it **c**heck**o**ut **b**ranch

**Example:**

```{"language": "text", "gutter": false}
$ gcob dev
Switched to a new branch 'dev'
```

***

## Log-gers

#### **gl**: git log

There are so many situations where the various flavors of **git log** can be
enormously helpful. Whether viewing patches of recent commits; viewing the
history of a branch, a single file, or even a single file on a branch; or
hunting down the source of a bug, **git log** is a powerhouse when it comes to
browsing a repository's history.

This alias is a shorthand for the basic **git log** command.

**Alias:**

```{"language": "bash", "gutter": false}
alias gl='git log'
```

**Mnemonic:**

- **g**it **l**og

**Example:**

```{"language": "text", "gutter": false}
$ gl
commit 6a742ad7998bc48d1b82ea51bb27b9a2f9b09b43
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 08:22:32 2015 -0400

    Add new file

commit 33be681231a9a06b5b0c6337346aa02ddff28914
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 08:21:48 2015 -0400

    Update modified_file

...
```

***

#### **glp**: git log with patches

This alias extends the normal **gl** alias by invoking **git log -p**. The
**-p** option to **git log** causes the git log display to include the diff
patches for each commit. This mode is enormously useful for reviewing the
nitty-gritty of a repository's recent commits.

Though I think there is probably a better way to do it, when combined with an
appropriate pager application like **less**, **glp** can give you the ability to
search a repository's history of patches. This can be very helpful in situations
where you have some idea of the cause of a bug, for example a method call to a
particular class, but don't know when or where a breaking change was introduced.
In such a situation, you could use **glp** and **less** to search the patch
history for references to the offending class as a means of tracking down the
source of the bug.

**Alias:**

```{"language": "bash", "gutter": false}
alias glp='git log -p'
```

**Mnemonic:**

- **g**it **l**og with **p**atches

**Example:**

```{"language": "text", "gutter": false}
$ glp
commit 6a742ad7998bc48d1b82ea51bb27b9a2f9b09b43
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 08:22:32 2015 -0400

    Add new file

diff --git a/new_file b/new_file
new file mode 100644
index 0000000..e69de29

commit 33be681231a9a06b5b0c6337346aa02ddff28914
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 08:21:48 2015 -0400

    Update modified_file

diff --git a/modified_file b/modified_file
index e69de29..cd08755 100644
--- a/modified_file
+++ b/modified_file
@@ -0,0 +1 @@
+Hello world!

...
```

***

#### **gls**: git log simple

On the opposite end of the spectrum from **git log -p** is the **git log
--oneline** command which I've aliased to **gls**. This alias will show a much
more abbreviated view of a repository's history where each commit is constrained
to a single line of information. This can be useful for getting a quick overview
of recent history in situations where author and date are not important.

**Alias:**

```{"language": "bash", "gutter": false}
alias gls='git log --oneline'
```

**Mnemonic:**

- **g**it **l**og **s**imple
- **g**it **ls**

**Example:**

```{"language": "text", "gutter": false}
$ gls
6a742ad Add new file
33be681 Update modified_file
ef018f5 Add modified_file
...
```

***

#### **glv**: git log visual

This alias provides a functionality similar to **gls**, however it invokes
**git log** with both the **--oneline** and **--graph** options. The **--graph**
option will cause git to draw a text-based graphical representation of the
commit history on the left hand side of the log output. When combined with
**--oneline** mode, this can make it easy to visualize merges and how a set of
changes was added to a given branch.

**Alias:**

```{"language": "bash", "gutter": false}
alias glv='git log --oneline --graph'
```

**Mnemonic:**

- **g**it **l**og **v**isual

**Example:**

```{"language": "text", "gutter": false}
$ glv
*   ec61508 Merge branch 'other_branch' into master
|\
| * d3d9daa Update stuff
| * 9158011 Add some stuff
* | bd1dec9 Add stuff with some things
|/
* 6a742ad Add new file
* 33be681 Update modified_file
...
```

***

## Diff aliases

#### **gd**: git diff

As its name suggests, **git diff** is a useful tool for showing changes between
commits, a commit and working tree, etc.

This alias is a shorthand for the vanilla **git diff** command.

**Alias:**

```{"language": "bash", "gutter": false}
alias gd='git diff'
```

**Mnemonic:**

- **g**it **d**iff

**Example:**

```{"language": "text", "gutter": false}
# Show the diff between the current branch and the master branch.
$ gd master
diff --git a/modified_file b/modified_file
index e69de29..cd08755 100644
--- a/modified_file
+++ b/modified_file
@@ -0,0 +1 @@
+Hello world!
diff --git a/new_file b/new_file
new file mode 100644
index 0000000..e69de29
```

***

#### **gds**: git diff staged

Similar to the normal **gd** alias, the **gds** alias tweaks the command
slightly by adding the **--staged** option which will cause **git diff** to show
the diff between HEAD (or another branch/commit) and any files currently staged
for the next commit.

**Alias:**

```{"language": "bash", "gutter": false}
alias gds='git diff --staged'
```

**Mnemonic:**

- **g**it **d**iff **s**taged

**Example:**

```{"language": "text", "gutter": false}
$ gds
diff --git a/modified_file b/modified_file
index cd08755..0a3ae34 100644
--- a/modified_file
+++ b/modified_file
@@ -1 +1 @@
-Hello world!
+Hola mundo!
```

***

## Tag team

I don't use tags every day, but I find that they're becoming more and more
common. Whether versioning private libraries using tags or pushing new versions
of bower components, it's increasingly necessary to have a familiarity with
git tags.

All of my **git tag** aliases are prefixed **gtag**. I haven't found a reason to
shorten these aliases any further just yet.

#### **gtagl**: git tag list

This alias displays a list of a repository's locally known tags.

**Alias:**

```{"language": "bash", "gutter": false}
alias gtagl="git tag -l"
```

**Mnemonic:**

- **g**it **tag** **l**ist

**Example:**

```{"language": "text", "gutter": false}
$ gtagl
0.8.20
0.8.21
0.8.3
0.8.4
0.8.5
0.8.6
0.8.7
0.8.8
0.8.9
0.9.0
0.9.1
```

***

#### **gtaga**: git tag add

This bash function creates a new tag. If given only one argument, **gtaga**
creates a tag where the provided argument is used as both the annotation and the
message of the new tag. When given two arguments, the first argument will be
used as the annotation of the tag and the second argument will be used as the
message of the tag.

**Function:**

```{"language": "bash", "gutter": false}
function gtaga() {
  [ -z "$1" ] && echo 'Invalid tag name!' && return
  [ -z "$2" ] && msg="$1" || msg="$2"
  git tag -a $1 -m $msg
}
```

**Mnemonic:**

- **g**it **tag** **a**dd

**Example:**

```{"language": "text", "gutter": false}
$ gtaga wip
# No output is shown when creating a tag.
$ git show wip
tag wip
Tagger: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 08:55:40 2015 -0400

Work in progress

commit 6a742ad7998bc48d1b82ea51bb27b9a2f9b09b43
Author: Danny Guinther <dannyguinther@gmail.com>
Date:   Thu Apr 9 08:22:32 2015 -0400

    Add new file

diff --git a/new_file b/new_file
new file mode 100644
index 0000000..e69de29
```

***

#### **gtagd**: git tag delete

This alias deletes an existing tag.

**Alias:**

```{"language": "bash", "gutter": false}
alias gtagd="git tag -d"
```

**Mnemonic:**

- **g**it **tag** **d**elete

**Example:**

```{"language": "text", "gutter": false}
$ gtagd wip
Deleted tag 'wip' (was 4a81695)
```

***

#### **gtagdr**: git tag delete remote

This alias deletes a remote tag from the repository's origin.

**Function:**

```{"language": "bash", "gutter": false}
function gtagdr() {
  [ -z "$1" ] && echo 'Invalid tag name!' && return
  git push origin :refs/tags/$1
}
```

**Mnemonic:**

- **g**it **tag** **d**elete **r**emote

**Example:**

```{"language": "text", "gutter": false}
$ gtagdr wip
To git@github.com:tdg5/some_repo.git
 - [deleted]         wip
```

***

## Miscellanea

#### **gputu**: git push and set upstream

Pushes to origin remote setting the upstream branch to a remote branch with the
same name as the current branch.  Alternatively, an argument may be provided to
use a different name for the remote branch.

Knowing this command is a wrapper around **git push -u** may help clarify where
the alias comes from: it is a **gput** with the **-u** or **--set-upstream**
option.

**Function:**

```{"language": "bash", "gutter": false}
function gputu() {
  if [ -z "$1" ]; then
    br="$(git rev-parse --abbrev-ref HEAD)"
  else
    br="$1"
  fi
  git push -u origin $br
}
```

**Mnemonic:**

- **g**it ~~push~~ **put** and set **u**pstream

**Example:**

```{"language": "text", "gutter": false}
$ gputu
Total 0 (delta 0), reused 0 (delta 0)
To git@github.com:tdg5/some_repo.git
 * [new branch]      wip -> wip
Branch wip set up to track remote branch wip from origin by rebasing.
```

***

#### **gcopr**: git checkout pull request

This command allows you to checkout a pull request ref from GitHub by Pull
Request ID. It's usually better to pull down a copy of the branch that the PR is
based on, but sometimes it can be useful to grab a snapshot of a pull request in
its current state.

By default this function will create a branch with the name
pull\_request_${id}, but you can specify a name by passing the desired name as
a second argument to the command.

**Function:**

```{"language": "bash", "gutter": false}
function gcopr() {
  ([ -z "$1" ] || [ $(($1)) -le 0 ]) && echo 'Invalid pull request ID' && return
  pr_id=$1
  [ -z "$2" ] && br_name="pull_request_${1}" || br_name="$2"
  git fetch origin pull/${pr_id}/head:${br_name}
  git checkout ${br_name}
}
```

**Mnemonic:**

- **g**it **c**heck**o**ut **p**ull **r**equest

**Example:**

```{"language": "text", "gutter": false}
$ gcopr 1408
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 5 (delta 0), reused 0 (delta 0), pack-reused 2
Unpacking objects: 100% (5/5), done.
From github.com:pry/pry
 * [new ref]         refs/pull/1408/head -> pull_request_1408
Switched to branch 'pull_request_1408'
```

***

## Bonus

#### **Bonus #1**: up: cd to root of git repo, home dir, then root

This shortcut is the creation of my former co-worker, Nicholas Ellis. It allows
you to navigate toward the root of a file-system with stops at a few convenient
paths. If you're in a git repo, the first call to **up** will **cd** you to the
root of the git repo. From the root of a git repo, a call to **up** will take
you to your home directory. Finally, from your home directory, a call to **up**
will take you to the root of the file-system.

**Alias:**

```{"language": "bash", "gutter": false}
alias up='[ $(git rev-parse --show-toplevel 2>/dev/null || echo ~) = $(pwd) ] && cd $([ $(echo ~) = $(pwd) ] && echo / || echo) || cd $(git rev-parse --show-toplevel 2>/dev/null)'
```

**Mnemonic:**

- Navigate **up** the file-system tree toward the root

**Example:**

```{"language": "text", "gutter": false}
tdg5@src/some_repo/app/models/concerns$ up
tdg5@src/some_repo$ up
tdg5@~$ up
tdg5@/$
```

***

#### **Bonus #2**: Add bash completion to aliases!

Did you know that you can add full git-enabled bash completion to your custom
git aliases?

Though the semantics vary depending on the version of git you use, recent
versions of git come with bash completion functions that allow you to configure
arbitrary commands to use git flavored bash completion.


Here's what that looks like on my system, YMMV.

```{"language": "bash", "gutter": false}
# Bash completion
__git_complete ga _git_add
__git_complete gap _git_add
__git_complete gau _git_add
__git_complete gback _git_reset
__git_complete gbr _git_branch
__git_complete gco _git_checkout
__git_complete gcp _git_cherry_pick
__git_complete gd _git_diff
__git_complete gg _git_grep
__git_complete ggi _git_grep
__git_complete ggno _git_grep
__git_complete gget _git_pull
__git_complete gl _git_log
__git_complete glv _git_log
__git_complete glp _git_log
__git_complete gput _git_push
__git_complete grb _git_rebase
__git_complete gs _git_status
__git_complete gsh _git_show
__git_complete gst _git_stash
__git_complete gundo _git_reset
```

***

#### **Bonus #3**: topcmds: **top** **c**o**m**man**ds**

This command is credit [Ben Orenstein](https://twitter.com/r00k).
The command scans your bash history and generates a list of your most frequently
used 1-2 word commands. The items high on this list are often good candidates for
aliasing.

[Ben Orenstien @ GoGaRuCo 2013](https://youtu.be/8ZMOWypU34k?t=807)

**Function:**

```{"language": "bash", "gutter": false}
function topcmds() {
  [ ! -z $1 ] && n="$1" || n="10"
  history | awk '{a[$2 " " $3]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -n $n
}
```

**Mnemonic:**

- The **top** n **c**o**m**man**ds** in the history file

**Example:**

```{"language": "text", "gutter": false}
$ topcmds
3166 gs
927 ls
414 gl
351 gap
303 gaa
223 gsh
221 gds
203 cd ..
196 ll
191 gd
```

***

## More git aliases

If you're git itch still hasn't been satisfied, check out pretty blog post or
talk by [Nicola Paolucci](https://twitter.com/durdn). He's a bona fide git
master with lots of aliases, tools, and tips for achieving a more streamlined
workflow with git.

- [One weird trick for powerful Git aliases](http://blogs.atlassian.com/2014/10/advanced-git-aliases/)
- [More Blog posts by Nicola Paolucci](http://blogs.atlassian.com/author/npaolucci/)
- [Nicola Paolucci - Becoming a Git Master - Atlassian Summit 2014](https://www.youtube.com/watch?v=-kVzV6m5_Qg)


## To be continued...

That's all the alias fun for today, kids! But don't worry, as I discover new
aliases that I can't live without, I'll be sure to share them. So, check back
for future posts with more helpful aliases for git and other applications.

Feel free to comment on any of the aliases I've suggested or to share any git
aliases you can't live without in the comments section below. It'd be great to
get a glimpse of how the rest of the world interacts with git and what I could
learn from those perspectives.

If you enjoyed this article, consider subscribing to my [RSS
feed](http://blog.tdg5.com/feed/) or following me on
[Twitter](https://twitter.com/dannyguinther). Thanks for reading!
