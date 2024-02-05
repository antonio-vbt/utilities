# Contents

- [Advanced rebasing: --onto](#advanced-rebasing---onto)
- [Tips for logs](#tips-for-logs)
- [Adding source commit to cherry-pick](#adding-source-commit-to-cherry-pick)
- [List all tracked files](#list-all-tracked-files)

# Advanced rebasing: --onto

Rebasing is a very useful tool in git to tidy up history and keep everything linear and concise. Simple rebases are pretty straightforward, bar the occasional conflict. Then interactive rebases are a tad more sophisticated, allowing dropping, squashing and even the reordering of commits. And then there is `rebase --onto`.

The situation where I had to use `--onto` was one where I needed to rebase only a subset of commits from a branch. To illustrate it:

```
M1---M2---M3---M4---M5---M6---M7 (main)
     \
      ----R1---R2                (release)
               \
                ----F1---F2---F3 (feature)
```

The story was this - in my work we cut off a release branch from `main` to have a stable point in time to anchor our releases. `main` continues being actively developed while critical patches also go into the release branch. I developed a feature on top of the release branch, as it needed to be tested in the field and I didn't want to introduce any instabilities from main while testing it.

Now I wanted to rebase it back to `main`. However, only the feature related commits, i.e. the patches in the release branch shouldn't be ported. This was what I was looking for:

```
M1---M2---M3---M4---M5---M6---M7             (main)
                              \
                               ----F1'---F3' (feature)
                                   ^^    ^^
```

A simple `rebase` wouldn't do, as it would include `R1` and `R2` with it. Commit `F2` in the illustration was also something I implemented only to aid my testing, but shouldn't go into the official code.

Now for this illustration a `cherry-pick` would be the simpler solution, but imagine this scenario had a signicantly larger amount of commits, making it impractical. Imagine also that I wanted to do some interactive rebase touch ups. `rebase --onto` to the rescue.

This is the workflow:

```
# First create a backup of the feature branch. This isn's strictly necessary, but
# `rebase --onto` will rewrite the branch and you may want to keep a copy
git checkout feature
git checkout -b feature_backup

# The actual rebase, interactive in this case so F2 can be dropped
git rebase -i --onto main release feature
```

So what this does is rebase the commits between `release` and `feature` *onto* `main`, i.e.`feature` will be modified to contain the commits in that range on top of `main` (the new base). Also note that the branch you're currently checked out to doesn't matter for this command, it will modify the branch in the last argument (`feature`) and will finish checked out to it.

- [git rebase documentation](https://git-scm.com/docs/git-rebase#_description)
- [How to cherry-pick a range of commits and merge them into another branch? - StackOverflow](https://stackoverflow.com/a/1994491)
- [What is the best way to git patch a subrange of a branch? - StackOverflow](https://stackoverflow.com/a/510453)


# Tips for logs

`git log` is the command to view history and consult previous commits. By default it outputs every single commit up to the current HEAD, which might be mostly clutter depending on what you're looking for. Here are some other ways to view commit logs.

`git show` is used to display information about a single commit. For when you're not interested in history, but in what a given commit does. By default it will also show diff.

`--name-only` will show the name of the files touched by a commit. It can be used with `git log` or `git show`, where it will suppress the diff. The diff of `show` can also be suppressed with `-s`.

When looking at logs it is not always that you want to know the author of a commit, its date or a long commit message. Sometimes you just want to see a quick list of commits to find a specific hash you're looking for. This is common enough that git already has an argument to do that:

```
git log --oneline
```

And if you just want to look at the N most recent commits, you can append `-[N]` to the above and skip printing the entire history.

I had a scenario recently where I was not satisfied with the output of `--oneline`. In my job we use a ton of tags and `--oneline` does not suppress these when printing its output. So my list of commits parseable at a glance was disrupted by a monstrosity of tags breaking the flow. After a quick google session I found this, which outputs exactly what I wanted:

```
git log --format="%C(auto) %h %s"
```

- [Source](https://stackoverflow.com/a/44679666)


# Adding source commit to cherry-pick

When cherry-picking a commit you may want to know its original source. Appending `-x` to the command will add a line to the new cherry-picked commit message mentioning the original commit.

```
git cherry-pick -x a1b2c3d4
```

# List all tracked files

If for some reason you want to check which files are being tracked by git, the `ls-tree` command is what you need. Here is an example of its usage with some additional, common, options:

```
git ls-tree --full-tree --name-only -r HEAD
```

In this example `--full-tree` is used to show all the files as if this was run from the root of the repo, `-r` is to recursively go into subdirectories, and `--name-only` is to suppress some additional information.

[Source](https://tech.serhatteker.com/post/2022-01/git-list-tracked-files/)
