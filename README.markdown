# ~/.config

Contains all of my dotfiles, which live in my [$XDG_CONFIG_HOME](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and the ones that don't are symlinked to `~/*`.

## Usage

    curl https://raw.githubusercontent.com/LukeChannings/.config/master/install | bash

## What it does

- Installs [Homebrew](https://github.com/Homebrew/brew), a package manager for macOS.
- Uses Homebrew's [Brewfile](https://github.com/Homebrew/homebrew-bundle) to install a set of apps, fonts, and command line utilities. No Ansible, Chef, or Puppet required!
- Installs additional dependencies for [NeoVim](https://neovim.io) and [FISH](https://fishshell.com)
- Configures macOS with my preferred defaults
- Installs software licenses from iCloud Drive
