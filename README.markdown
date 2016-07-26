# Luke's DotConfig

Configurations for:

- [FISH](https://fishshell.com)
- [NeoVIM](https://neovim.io)
- [TMUX](https://tmux.github.io)
- [Git](https://git-scm.com)

## Dependencies

```bash
brew install fish tmux ag reattach-to-user-namespace fzf neovim/neovim/neovim editorconfig
sudo pip install neovim
cd ~/.vim/plugged/tern_for_vim
npm install
```

### FZF

Install `fzf_key_bindings` on OS X with /usr/local/opt/fzf/install. For others look at [the GitHub page](https://github.com/junegunn/fzf#installation).

## NVM

`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash`

## Usage

Clone into `~/.config` with:

```bash
rm -rf ~/.config
git clone https://github.com/TheFuzzball/dotconfig.git ~/.config
exec fish
fundle install
```
