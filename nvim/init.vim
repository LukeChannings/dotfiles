" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin', {
      \ 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
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
Plug 'embear/vim-localvimrc'
Plug 'eugen0329/vim-esearch'
Plug 'szw/vim-tags'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['handlebars'] }
Plug 'sbdchd/neoformat'
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
let g:python2_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:enable_bold_font = 1
let g:terminal_scrollback_buffer_size = 2147483647
let g:javascript_enable_domhtmlcss = 1
let g:vim_markdown_folding_disabled = 1
let g:ackprg = 'rg --files --hidden --follow --glob "!{.git,node_modules}/*"'


" Emmet
let g:user_emmet_install_global = 0
let g:user_emmet_mode='a'
autocmd FileType html,*.handlebars EmmetInstall

" neoformat
let g:neoformat_only_msg_on_error = 1
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

let g:neoformat_enabled_python = ['autopep8']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_scss = ['prettier']
let g:neoformat_enabled_graphql = ['prettier']

function! neoformat#formatters#javascript#prettier() abort
  return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--no-semi', '--print-width 80'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#typescript#prettier() abort
  return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--no-semi'],
        \ 'stdin': 1,
        \ }
endfunction

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
au TermOpen * setlocal nonumber norelativenumber

com! FormatJSON %!python -m json.tool
cnoremap w!! w !sudo tee > /dev/null %

let g:neomake_python_enabled_makers = ['pylint']

autocmd BufWritePost,BufWinEnter * Neomake

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

filetype indent on
set shiftwidth=2
set smartindent
highlight ColorColumn ctermbg=black
set colorcolumn=80

set hidden
set nocompatible

if has("termguicolors")
  hi! Normal ctermbg=NONE guibg=NONE
endif

if has("gui_vimr")
  set background = dark
endif
