# dotfiles
## Requirements

Set zsh as your login shell:

    chsh -s $(which zsh)

## Install

Clone onto your laptop:

    git clone git@github.com:Albatrosicks/dotfiles.git ~/dotfiles

Install [rcm](https://github.com/thoughtbot/rcm):

    brew install rcm

Install the dotfiles:

    env RCRC=$HOME/dotfiles/rcrc rcup

After the initial installation, you can run `rcup` without the one-time variable
`RCRC` being set (`rcup` will symlink the repo's `rcrc` to `~/.rcrc` for future
runs of `rcup`). [See
example](https://github.com/Albatrosicks/dotfiles/blob/master/rcrc).

This command will create symlinks for config files in your home directory.
Setting the `RCRC` environment variable tells `rcup` to use standard
configuration options:

- Exclude the `README.md`, `README-ES.md` and `LICENSE` files, which are part of
  the `dotfiles` repository but do not need to be symlinked in.
- Give precedence to personal overrides which by default are placed in
  `~/dotfiles-local`
- Please configure the `rcrc` file if you'd like to make personal
  overrides in a different directory

## Update

From time to time you should pull down any updates to these dotfiles, and run

    rcup

to link any new files and install new vim plugins. **Note** You _must_ run
`rcup` after pulling to ensure that all files in plugins are properly installed,
but you can safely run `rcup` multiple times so update early and update often!

## Make your own customizations

Create a directory for your personal customizations:

    mkdir ~/dotfiles-local

Put your customizations in `~/dotfiles-local` appended with `.local`:

- `~/dotfiles-local/aliases.local`
- `~/dotfiles-local/git_template.local/*`
- `~/dotfiles-local/gitconfig.local`
- `~/dotfiles-local/psqlrc.local` (we supply a blank `.psqlrc.local` to prevent `psql` from
  throwing an error, but you should overwrite the file with your own copy)
- `~/dotfiles-local/tmux.conf.local`
- `~/dotfiles-local/vimrc.local`
- `~/dotfiles-local/vimrc.bundles.local`
- `~/dotfiles-local/zshrc.local`
- `~/dotfiles-local/zsh/configs/*`

For example, your `~/dotfiles-local/aliases.local` might look like this:

    # Productivity
    alias todo='$EDITOR ~/.todo'

Your `~/dotfiles-local/gitconfig.local` might look like this:

    [alias]
      l = log --pretty=colored
    [pretty]
      colored = format:%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset
    [user]
      name = Dan Croak
      email = dan@thoughtbot.com

To extend your `git` hooks, create executable scripts in
`~/dotfiles-local/git_template.local/hooks/*` files.

Your `~/dotfiles-local/zshrc.local` might look like this:

    # load pyenv if available
    if which pyenv &>/dev/null ; then
      eval "$(pyenv init -)"
    fi

## zsh Configurations

Additional zsh configuration can go under the `~/dotfiles-local/zsh/configs` directory. This
has two special subdirectories: `pre` for files that must be loaded first, and
`post` for files that must be loaded last.

For example, `~/dotfiles-local/zsh/configs/pre/virtualenv` makes use of various shell
features which may be affected by your settings, so load it first:

    # Load the virtualenv wrapper
    . /usr/local/bin/virtualenvwrapper.sh

Setting a key binding can happen in `~/dotfiles-local/zsh/configs/keys`:

    # Grep anywhere with ^G
    bindkey -s '^G' ' | grep '

Some changes, like `chpwd`, must happen in `~/dotfiles-local/zsh/configs/post/chpwd`:

    # Show the entries in a directory whenever you cd in
    function chpwd {
      ls
    }

This directory is handy for combining dotfiles from multiple teams; one team
can add the `virtualenv` file, another `keys`, and a third `chpwd`.

The `~/dotfiles-local/zshrc.local` is loaded after `~/dotfiles-local/zsh/configs`.

## What's in it?

- [fzf](https://github.com/junegunn/fzf.vim) for fuzzy file/buffer/tag finding.
- Set `<leader>` to a single space.
- Switch between the last two files with space-space.
- Syntax highlighting for Markdown, HTML, JavaScript, Ruby, Go, Elixir, more.
- Use [Ag](https://github.com/ggreer/the_silver_searcher) instead of Grep when
  available.
- Map `<leader>ct` to re-index ctags.

[git](http://git-scm.com/) configuration:

- Adds a `co-upstream-pr $PR_NUMBER $LOCAL_BRANCH_NAME` subcommand to checkout remote upstream branch into a local branch.
- Adds a `create-branch` alias to create feature branches.
- Adds a `delete-branch` alias to delete feature branches.
- Adds a `merge-branch` alias to merge feature branches into master.
- Adds an `up` alias to fetch and rebase `origin/master` into the feature
  branch. Use `git up -i` for interactive rebases.
- Adds `post-{checkout,commit,merge}` hooks to re-index your ctags.
- Adds `pre-commit` and `prepare-commit-msg` stubs that delegate to your local
  config.
- Adds `trust-bin` alias to append a project's `bin/` directory to `$PATH`.

Shell aliases and scripts:

- `...` for quicker navigation to the parent's parent directory.
- `g` with no arguments is `git status` and with arguments acts like `git`.
- `mcd` to make a directory and change into it.
- `replace foo bar **/*.rb` to find and replace within a given list of files.
- `v` for `$VISUAL`.
- `path` for pretty print ``$PATH`
- `docker` use `finch` instead of docker
- `forget` to remove last history entry
- `lg` shortcut for `lazygit`
- `intel` to run app with Rosetta
- `btop` shortcut to bpytop
