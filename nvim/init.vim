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
set nolazyredraw
set relativenumber
set columns=80
set wildignore+=node_modules/**,dist/**
set autoread
filetype plugin on

let g:enable_bold_font = 1
let g:terminal_scrollback_buffer_size = 2147483647
let g:javascript_enable_domhtmlcss = 1
let g:vim_markdown_folding_disabled = 1
let g:ackprg = 'ag --nogroup --nocolor --column'
let $fzf_default_command = 'ag -l -g ""'

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

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
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

com! FormatJSON %!python -m json.tool
