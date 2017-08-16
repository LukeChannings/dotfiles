 " Plugins
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'joshdick/onedark.vim'
  Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin', {
    \ 'on':  'NERDTreeToggle' }
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'scrooloose/nerdcommenter'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'mattn/emmet-vim', { 'for': ['html'] }
  Plug 'benekastah/neomake'
  Plug 'tpope/vim-jdaddy'
  Plug 'vim-airline/vim-airline'
  Plug 'jaawerth/nrun.vim'
  Plug 'tpope/vim-surround'
  Plug 'ternjs/tern_for_vim', { 'for': ['javascript'] }
  Plug 'plasticboy/vim-markdown'
  Plug 'Valloric/YouCompleteMe'
  Plug 'tpope/vim-unimpaired'
  Plug 'sheerun/vim-polyglot'
  Plug 'vim-scripts/BufOnly.vim'
  Plug 'vim-scripts/scratch.vim'
  Plug 'wellle/targets.vim'
  Plug 'wakatime/vim-wakatime'
  Plug 'embear/vim-localvimrc'
  Plug 'eugen0329/vim-esearch'
  Plug 'szw/vim-tags'
  Plug 'mustache/vim-mustache-handlebars', { 'for': ['handlebars'] }
  " post install (yarn install | npm install) then load plugin only for editing supported files
  Plug 'prettier/vim-prettier', { 
    \ 'do': 'yarn install', 
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql'] } 
call plug#end()

set shell=sh
set number
set tabstop=2
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:⇥\ ,space:·,
set list
set nolazyredraw
set relativenumber
set columns=80
set wildignore+=node_modules/**,dist/**
set autoread
set splitright
set splitbelow
filetype plugin on

let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:enable_bold_font = 1
let g:terminal_scrollback_buffer_size = 2147483647
let g:javascript_enable_domhtmlcss = 1
let g:vim_markdown_folding_disabled = 1
let g:ackprg = 'ag --nogroup --nocolor --column'
let $fzf_default_command = 'ag -l -g ""'


" Emmet
let g:user_emmet_install_global = 0
let g:user_emmet_mode='a'
autocmd FileType html,*.handlebars EmmetInstall

" Prettier
let g:prettier#exec_cmd_async = 1
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.json,*.css,*.scss,*.less,*.graphql PrettierAsync
let g:prettier#config#semi = 'false'
let g:prettier#config#trailing_comma = 'none'

" syntax highlighting
set background=dark
syntax on
colorscheme onedark
let g:airline_theme='onedark'

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors")) && $TERM_PROGRAM ==# 'iTerm.app'
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
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
map <C-n> :NERDTreeToggle<CR>

" let g:loaded_ruby_provider=1
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'
let g:EditorConfig_core_mode = 'external_command'

" Use system clipboard
set clipboard=unnamed

" Leaders

let mapleader = "\<Space>"
noremap \\ :call NERDComment(0,"toggle")<CR>
nmap <leader>n :cnext<CR>
nmap <leader>N :cprev<CR>
nmap <leader>c :tabedit \| term fish<CR>
nmap <leader>x :bd!<CR>
nmap <leader>\| :vsp \| term fish<CR>
nmap <leader>- :sp \| term fish<CR>
nmap <leader>f :vimgrep 
nmap <leader>q :q<CR>
nmap <leader><ESC> :noh<CR>
nmap <leader>t :Buffers<CR>
inoremap <S-CR> <Esc>

autocmd TermOpen * set bufhidden=hide
autocmd TermOpen * setl nolist

com! FormatJSON %!python -m json.tool
cnoremap w!! w !sudo tee > /dev/null %

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

filetype indent on
set shiftwidth=2
set smartindent
highlight ColorColumn ctermbg=red
set colorcolumn=80

set hidden
set nocompatible

if has("termguicolors")
  hi! Normal ctermbg=NONE guibg=NONE
endif
