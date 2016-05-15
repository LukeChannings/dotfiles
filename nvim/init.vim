" Plugins
call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-sensible'
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'benekastah/neomake'
	Plug 'mattn/emmet-vim'
	Plug 'guns/xterm-color-table.vim'
	Plug 'tpope/vim-jdaddy'
	Plug 'jelera/vim-javascript-syntax'
	Plug 'pangloss/vim-javascript'
	Plug 'vim-airline/vim-airline'
	Plug 'joshdick/onedark.vim'
	Plug 'joshdick/airline-onedark.vim'
	Plug 'jaawerth/nrun.vim'
	Plug 'scrooloose/nerdtree'
	Plug 'scrooloose/nerdcommenter'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tpope/vim-surround'
	Plug 'reedes/vim-colors-pencil'
call plug#end()

set number
set tabstop=2
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:⇥\ ,space:·,
set list
filetype plugin on

let g:enable_bold_font = 1
let g:javascript_enable_domhtmlcss = 1
"set foldmethod=syntax
let $fzf_default_command = 'ag -l -g ""'
set shell=fish
set columns=80

" eslint
let b:neomake_javascript_eslint_exe = nrun#Which('eslint')
let b:neomake_javascript_enabled_makers = ['eslint']
autocmd! BufWritePost * Neomake
let g:user_emmet_install_global = 0
autocmd FileType html,css,scss EmmetInstall

" Split panes

" Move lines up / down with alt+k/j
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" syntax highlighting
set background=dark
syntax on
color onedark
let g:airline_theme='onedark'
if has("nvim")
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Custom key mappings
map <C-P> :FZF<CR>
noremap <C-T> :Buffers<CR>

" Unbind arrow keys. Break the habit...
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

noremap <C-\> :NERDTreeToggle<CR>
noremap <leader>\ :call NERDComment(0,"toggle")<CR>
