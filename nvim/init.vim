 " Plugins
call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-sensible'
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'benekastah/neomake'
  Plug 'mattn/emmet-vim'
  Plug 'guns/xterm-color-table.vim'
  Plug 'tpope/vim-jdaddy'
  Plug 'vim-airline/vim-airline'
  Plug 'joshdick/onedark.vim'
  Plug 'joshdick/airline-onedark.vim'
  Plug 'jaawerth/nrun.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
  Plug 'reedes/vim-colors-pencil'
  Plug 'takac/vim-hardtime'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'ternjs/tern_for_vim'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'Valloric/YouCompleteMe'
  Plug 'tpope/vim-unimpaired'
  Plug 'sheerun/vim-polyglot'
call plug#end()

set number
set tabstop=2
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:⇥\ ,space:·,
set list
filetype plugin on

let g:enable_bold_font = 1
let g:terminal_scrollback_buffer_size = 2147483647
let g:javascript_enable_domhtmlcss = 1
let g:vim_markdown_folding_disabled = 1
let g:ackprg = 'ag --nogroup --nocolor --column'
set relativenumber
let $fzf_default_command = 'ag -l -g ""'
set columns=80
set wildignore+=node_modules/**,dist/**

" eslint
let g:neomake_javascript_eslint_exe = nrun#Which('eslint')
let g:neomake_javascript_enabled_makers = ['eslint']
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
autocmd! BufWritePost * Neomake
autocmd InsertChange,TextChanged * update | Neomake

" Emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css,scss EmmetInstall

" syntax highlighting
set background=dark
syntax on
colorscheme onedark
let g:airline_theme='onedark'
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Custom key mappings
map <C-P> :FZF<CR>
noremap <C-T> :Buffers<CR>

" Unbind arrow keys. Break the habit...
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

noremap <leader>\ :call NERDComment(0,"toggle")<CR>
map <C-n> :NERDTreeToggle<CR>

let g:hardtime_default_on = 1

" Use system clipboard
set clipboard=unnamed

nmap <leader> <RIGHT> :cnext<CR>
nmap <leader> <LEFT> :cprev<CR>
nnoremap <leader> d :call TernDef<CR>

autocmd TermOpen * set bufhidden=hide
autocmd TermOpen * setl nolist

set autoread

com! FormatJSON %!python -m json.tool
