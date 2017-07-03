# Luke's DotConfig

## Usage

    curl https://raw.githubusercontent.com/LukeChannings/.config/master/install | bash

## What does it do?

1. Links iCloud Drive ssh folder -> ~/.ssh (if iCloud Drive ssh folder exists)
2. Clones LukeChannings/.config into ~/.config
3. (If macOS) installs HomeBrew and packages defined in the Brewfile
4. (If macOS) sets up FZF key bindings
5. Links ~/.config to ~/* where needed
6. Installs NeoVim support files (Will still need to :PlugInstall)
7. Installs FISH packages
