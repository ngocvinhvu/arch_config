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
" Plug 'vim-scripts/indentpython.vim'
Plug 'lepture/vim-jinja'
" Plug 'pangloss/vim-javascript'
Plug 'ycm-core/YouCompleteMe' 
"required npm, libnghttp2; deleting third_party/ycmd/third_party/tern_runtime/node_module dir for javascript compleition
Plug 'tpope/vim-surround'
Plug 'echuraev/translate-shell.vim'
" Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'vim-scripts/colorizer'
call plug#end()

filetype plugin indent on
filetype on
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
set number
set relativenumber

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
" setlocal noexpandtab
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


" colorscheme onedark

" lightline
" set noshowmode
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
map <leader>n :call NERDTreeToggle()<CR>
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
" map <leader>s :SyntasticCheck<CR>
" map <leader>d :SyntasticReset<CR>
" map <leader>e :lnext<CR>
" map <leader>r :lprev<CR>

" tag list
map <leader>t :TagbarToggle<CR>

" copy, cut and paste
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

map <leader>r :Run<CR>
map <leader>b :Break<CR>
map <leader><leader>b :Clear<CR>
map <leader>s :Over<CR>
map <leader>c :Continue<CR>
map <leader>p :Stop<CR>
map <leader>f :Finish<CR>
let g:termdebug_wide=1

vnoremap <leader>y "+y
vnoremap Y "+y
inoremap jk <esc>
set timeoutlen=300
nnoremap <silent> ,t :tabnew<CR>
nnoremap <silent> ,d :tabclose<CR>
nnoremap <silent> ,D :qa!<CR>
nnoremap <silent> <C-tab> gt
nnoremap <silent> <S-tab> gT
vnoremap <silent> ,, :Trans :vi -b<CR> 
map ,f ,t:FZF ~/<CR>
augroup vim_autocmd
	" fix always tabs to spaces when start python file
	" fuck /usr/share/vim/vim74/ftplugin/python.vim
	autocmd FileType python setlocal ts=4 sts=4 sw=4 noexpandtab
	autocmd Filetype python inoremap <silent>  <buffer> <F9> <Esc>:%w !python3<CR>
	autocmd Filetype python nnoremap <silent> <buffer> <F9> :%w !python3<CR>
	autocmd Filetype python nnoremap <silent> <buffer> <F8> :w<CR>:!clear;python3 %<CR>
	autocmd Filetype python vnoremap <silent> <buffer> <F9> !python3<CR>
	autocmd Filetype python inoremap <silent> <buffer> <F5> <Esc>:%w !sudo python3<CR>
	autocmd Filetype python nnoremap <silent> <buffer> <F5> :%w !sudo python3<CR>
	autocmd Filetype php inoremap <silent> <buffer> <F9> <Esc>:%w !php<CR>
	autocmd Filetype php nnoremap <silent> <buffer> <F9> :%w !php<CR>
	autocmd Filetype php vnoremap <silent> <buffer> <F9> !php<CR>
	autocmd Filetype php inoremap <silent> <buffer> <F5> <Esc>:%w !sudo php<CR>
	autocmd Filetype php nnoremap <silent> <buffer> <F5> :%w !sudo php<CR>
	autocmd Filetype sh inoremap <silent> <buffer> <F9> <Esc>:%w !bash<CR>
	autocmd Filetype sh nnoremap <silent> <buffer> <F9> :%w !bash<CR>
	autocmd Filetype sh vnoremap <silent> <buffer> <F9> !bash<CR>
	autocmd Filetype sh nnoremap <silent> <buffer> <F8> :w<CR>:!clear; bash %<CR>
	autocmd Filetype javascript inoremap <silent> <buffer> <F9> <Esc>:%w !node<CR>
	autocmd Filetype javascript nnoremap <silent> <buffer> <F9> :%w !node<CR>
	autocmd Filetype javascript vnoremap <silent> <buffer> <F9> !node<CR>
	autocmd Filetype perl inoremap <silent> <buffer> <F9> <Esc>:%w !perl<CR>
	autocmd Filetype perl nnoremap <silent> <buffer> <F9> :%w !perl<CR>
	autocmd Filetype perl vnoremap <silent> <buffer> <F9> !perl<CR>
	autocmd Filetype perl nnoremap <silent> <buffer> <F8> :w<CR>:!perl %<CR>
	autocmd Filetype c nnoremap  <F8> :w<CR>:Shell gcc -g % >/dev/null;./a.out<CR><C-w><C-w>
	autocmd Filetype c inoremap  <F8> <Esc>:w<CR>:Shell gcc -g % >/dev/null;./a.out<CR><C-w><C-w>
	autocmd Filetype c nnoremap  <F9> :w<CR>:!clear;gcc -g % ;./a.out<CR>
	autocmd Filetype c inoremap  <F9> <Esc>:w<CR>:!clear; gcc -g % ;./a.out<CR>
	autocmd Filetype c nnoremap  <F5> :w<CR>:!gcc -g %<CR>:packadd termdebug<CR>:Termdebug<CR>
	autocmd Filetype cpp nnoremap  <F8> :w<CR>:Shell g++ -g % >/dev/null;./a.out<CR><C-w><C-w>
	autocmd Filetype cpp inoremap  <F8> <Esc>:w<CR>:Shell g++ -g % >/dev/null;./a.out<CR><C-w><C-w>
	autocmd Filetype cpp nnoremap  <F9> :w<CR>:!clear;g++ -g % ;./a.out<CR>
	autocmd Filetype cpp inoremap  <F9> <Esc>:w<CR>:!clear; g++ -g % ;./a.out<CR>
	autocmd Filetype cpp nnoremap  <F5> :w<CR>:!g++ -g %<CR>:packadd termdebug<CR>:Termdebug<CR>

set scrolloff=999999
" if !has('nvim')
"     set mouse=a
"     set ttymouse=xterm2
" endif
set cmdheight=2
set smartcase
set ignorecase
set path+=**
set hlsearch incsearch
set nrformats-=octal "fix when <c-a> auto add 07 to 10
set cursorline
hi CursorLine	cterm=NONE ctermbg=227
hi Visual ctermfg=NONE ctermbg=11
hi MatchParen ctermfg=Black ctermbg=LightCyan
hi CursorLineNr term=none cterm=none ctermfg=202 
hi Search term=none cterm=none ctermfg=Black ctermbg=LightCyan

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
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78


let $FZF_DEFAULT_COMMAND = "find -L"



if !exists("my_auto_commands_loaded")
    let my_auto_commands_loaded = 1
    " Large files are > 10M
    " Set options:
    " eventignore+=FileType (no syntax highlighting etc
    " assumes FileType always on)
    " noswapfile (save copy of file)
    " bufhidden=unload (save memory when other file is viewed)
    " buftype=nowrite (file is read-only)
    " undolevels=-1 (no undo possible)
    let g:LargeFile = 1024 * 1024 * 10
    augroup LargeFile
        autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
    augroup END
endif


function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  " silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
