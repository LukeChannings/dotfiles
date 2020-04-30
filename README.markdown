# ~/.config

      ________  ________  ________   ________ ___  ________
    |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\
    \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|
      \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___
    __\ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \
    |\__\ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
    \|__|\|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|

Contains all of my dotfiles, which live in my [$XDG_CONFIG_HOME](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and the ones that don't are symlinked to `~/*`.

## Usage

    curl https://raw.githubusercontent.com/LukeChannings/.config/master/install | bash

Or in a container:

   `docker run -it lukechannings/terminal`

## Goals

- Quickly set up a new machine with all my software and preferences
- Easy to maintain - I don't want an ansible configuration, just something simple and diffable
- Works on macOS and Linux
