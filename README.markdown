# Luke's DotConfig

Configurations for:

- [FISH](https://fishshell.com)
- [NeoVIM](https://neovim.io)

## Dependencies

`brew install fish tmux ag reattach-to-user-namespace fzf neovim/neovim/neovim`

## NVM

`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash`

## Usage

Clone into `~/.config` with:

```bash
git clone https://github.com/TheFuzzball/dotconfig.git ~/.config
exec fish
vundle install
```
