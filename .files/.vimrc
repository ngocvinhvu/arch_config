" plugins
let need_to_install_plugins = 0
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	let need_to_install_plugins = 1
endif

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/indentpython.vim'
Plug 'lepture/vim-jinja'
Plug 'pangloss/vim-javascript'
Plug 'ycm-core/YouCompleteMe' "required npm, libnghttp2
Plug 'tpope/vim-surround'
Plug 'echuraev/translate-shell.vim'
Plug 'junegunn/fzf.vim'
call plug#end()

filetype plugin indent on
syntax on

if need_to_install_plugins == 1
	echo "Installing plugins..."
	silent! PlugInstall
	echo "Done!"
	q
endif

" always show the status bar
set laststatus=2

" enable 256 colors
set t_Co=256
set t_ut=

" turn on line numbering
set relativenumber

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set viminfo='25,\"50,n~/.viminfo

" word movement
imap <S-Left> <Esc>bi
nmap <S-Left> b
imap <S-Right> <Esc><Right>wi
nmap <S-Right> w

" indent/unindent with tab/shift-tab
" nmap <Tab> >>
" imap <S-Tab> <Esc><<i
" nmap <S-tab> <<

" mouse
set ttymouse=sgr
set mouse=a
let g:is_mouse_enabled = 1
noremap <silent> <leader>m :call ToggleMouse()<CR>
function ToggleMouse()
	if g:is_mouse_enabled == 1
		echo "Mouse OFF"
		set mouse=
		let g:is_mouse_enabled = 0
	else
		echo "Mouse ON"
		set mouse=a
		let g:is_mouse_enabled = 1
	endif
endfunction


" color scheme
syntax on
" colorscheme onedark
filetype on
filetype plugin indent on

" lightline
set noshowmode
let g:lightline = { 'colorscheme': 'onedark' }

" code folding
set foldmethod=indent
set foldlevel=99
" zM close all and set foldlevel to 0
" zR open all and set highest foldlevel
nnoremap <space> za
" wrap toggle
setlocal nowrap
noremap <silent> ,w :call ToggleWrap()<CR>
function ToggleWrap()
	if &wrap
		echo "Wrap OFF"
		setlocal nowrap
		set virtualedit=all
		silent! nunmap <buffer> <Up>
		silent! nunmap <buffer> <Down>
		silent! nunmap <buffer> <Home>
		silent! nunmap <buffer> <End>
		silent! iunmap <buffer> <Up>
		silent! iunmap <buffer> <Down>
		silent! iunmap <buffer> <Home>
		silent! iunmap <buffer> <End>
	else
		echo "Wrap ON"
		setlocal wrap linebreak nolist
		set virtualedit=
		setlocal display+=lastline
		noremap  <buffer> <silent> <Up>   gk
		noremap  <buffer> <silent> <Down> gj
		noremap  <buffer> <silent> <Home> g<Home>
		noremap  <buffer> <silent> <End>  g<End>
		inoremap <buffer> <silent> <Up>   <C-o>gk
		inoremap <buffer> <silent> <Down> <C-o>gj
		inoremap <buffer> <silent> <Home> <C-o>g<Home>
		inoremap <buffer> <silent> <End>  <C-o>g<End>
	endif
endfunction

" move through split windows
" nmap <leader><Up> :wincmd k<CR>
" nmap <leader><Down> :wincmd j<CR>
" nmap <leader><Left> :wincmd h<CR>
" nmap <leader><Right> :wincmd l<CR>

" move through buffers
" nmap <leader>[ :bp!<CR>
" nmap <leader>] :bn!<CR>
" nmap <leader>x :bd<CR>

" restore place in file from previous session
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" file browser
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0
map <leader>b :call NERDTreeToggle()<CR>
function NERDTreeToggle()
	NERDTreeTabsToggle
	if g:nerdtree_open == 1
		let g:nerdtree_open = 0
	else
		let g:nerdtree_open = 1
		wincmd p
	endif
endfunction

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
map <leader>s :SyntasticCheck<CR>
map <leader>d :SyntasticReset<CR>
map <leader>e :lnext<CR>
map <leader>r :lprev<CR>

" tag list
map <leader>t :TagbarToggle<CR>

" copy, cut and paste
vmap Y "+y
vmap <leader>x "+c
vmap <C-A-v> <ESC>"+p
imap <C-A-v> <ESC>"+pa

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! XTermPasteBegin()
	set pastetoggle=<Esc>[201~
	set paste
	return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()


"""" mine
"Mode Settings
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[1 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)
"Cursor settings:
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

" vnoremap <leader>y "+y
inoremap jk <esc>
set timeoutlen=400
inoremap <C-t> <esc>:tabnew<CR>
nnoremap <C-t> <esc>:tabnew<CR>
nnoremap <C-Tab> :tabn<CR>
vnoremap <silent> ,, :Trans :vi<CR>
"nnoremap <c-p> :find 
nnoremap <c-p> :FZF ~/<CR>
augroup vim_autocmd
	autocmd Filetype python inoremap <silent>  <buffer> <F9> <Esc>:%w !python<CR>
	autocmd Filetype python nnoremap <silent> <buffer> <F9> :%w !python<CR>
	autocmd Filetype python vnoremap <silent> <buffer> <F9> !python<CR>
	autocmd Filetype python inoremap <silent> <buffer> <F8> <Esc>:%w !sudo python<CR>
	autocmd Filetype python nnoremap <silent> <buffer> <F8> :%w !sudo python<CR>
	autocmd Filetype php inoremap <silent> <buffer> <F9> <Esc>:%w !php<CR>
	autocmd Filetype php nnoremap <silent> <buffer> <F9> :%w !php<CR>
	autocmd Filetype php vnoremap <silent> <buffer> <F9> !php<CR>
	autocmd Filetype php inoremap <silent> <buffer> <F8> <Esc>:%w !sudo php<CR>
	autocmd Filetype php nnoremap <silent> <buffer> <F8> :%w !sudo php<CR>
	autocmd Filetype sh inoremap <silent> <buffer> <F9> <Esc>:%w !bash<CR>
	autocmd Filetype sh nnoremap <silent> <buffer> <F9> :%w !bash<CR>
	autocmd Filetype sh vnoremap <silent> <buffer> <F9> !bash<CR>
	autocmd Filetype javascript inoremap <silent> <buffer> <F9> <Esc>:%w !node<CR>
	autocmd Filetype javascript nnoremap <silent> <buffer> <F9> :%w !node<CR>
	autocmd Filetype javascript vnoremap <silent> <buffer> <F9> !node<CR>
	autocmd Filetype perl inoremap <silent> <buffer> <F9> <Esc>:%w !perl<CR>
	autocmd Filetype perl nnoremap <silent> <buffer> <F9> :%w !perl<CR>
	autocmd Filetype perl vnoremap <silent> <buffer> <F9> !perl<CR>
	autocmd Filetype c inoremap  <silent> <buffer> <F9> <Esc>:w<CR>:!clear;gcc %;./a.out<CR>
	autocmd Filetype c nnoremap <silent> <buffer> <F9> :w<CR>:!clear;gcc %;./a.out<CR>
	autocmd Filetype cpp inoremap  <silent> <buffer> <F9> <Esc>:w<CR>:!clear;g++ %;./a.out<CR>
	autocmd Filetype cpp nnoremap  <silent> <buffer> <F9> :w<CR>:!clear;g++ %;./a.out<CR>
augroup END
set scrolloff=999999
" if !has('nvim')
"     set mouse=a
"     set ttymouse=xterm2
" endif
set smartcase
set ignorecase
set path+=**
set hlsearch incsearch
set nrformats-=octal "fix when <c-a> auto add 07 to 10
set cursorline
hi CursorLine	cterm=NONE ctermbg=11
hi CursorLineNr term=none cterm=none ctermfg=202 
hi Search term=none cterm=none ctermfg=black ctermbg=red

let g:is_expandtab_enabled = 1
map <F2> :call ToggleExpandTab()<CR>
function ToggleExpandTab()
	if g:is_expandtab_enabled == 1
		echo "tab to spaces OFF"
		set noexpandtab
                set tabstop=4
		%retab!
		let g:is_expandtab_enabled = 0
	else
		echo "tab to spaces ON"
		set expandtab
                set tabstop=4
		retab
		let g:is_expandtab_enabled = 1
	endif
endfunction

" close scratch buffer YouCompleteMe
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_autoclose_preview_window_after_completion = 1

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78


let $FZF_DEFAULT_COMMAND = "find -L"
