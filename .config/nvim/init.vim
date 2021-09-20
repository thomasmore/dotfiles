set nowrap
set number
set relativenumber
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber

set scrolloff=5
nnoremap <c-m-up> 1<c-u>
nnoremap <c-m-down> 1<c-d>

set mouse=a

set inccommand=split

" windows layout
set winwidth=80
set winheight=20
set winminwidth=15
set winminheight=5

" default tabulation
set tabstop=4
set shiftwidth=4
set expandtab

" tab support
nnoremap <f3> :tabnew<cr>
nnoremap <f4> :tabprev<cr>
nnoremap <f5> :tabnext<cr>

" folding
set foldmethod=syntax
set foldlevelstart=6

set signcolumn=number
" Toggle signcolumn
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        let b:signcolumn_on=0
    else
        set signcolumn=number
        let b:signcolumn_on=1
    endif
endfunction

" Indentline
let g:indentLine_color_gui = '#555555'
let g:indentLine_char = '▏'
let g:indentLine_fileTypeExclude=['json']
nnoremap <Leader>i :IndentLinesToggle<cr>:set invnumber<cr>:set invrelativenumber<cr>:call ToggleSignColumn()<cr>

" highlight long lines
match ErrorMsg /\%121v.\+/

" open at last edit
au BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |  exe "normal! g`\""
  \ | endif

" split to below and right
set splitbelow
set splitright

nnoremap <M-right> <c-w>l
nnoremap <M-l> <c-w>l
nnoremap <M-left> <c-w>h
nnoremap <M-h> <c-w>h
nnoremap <M-up> <c-w>k
nnoremap <M-k> <c-w>k
nnoremap <M-down> <c-w>j
nnoremap <M-j> <c-w>j

" searching
set hlsearch
nnoremap <f2> :nohlsearch<cr>
set ignorecase
set smartcase
set incsearch

" linting/compiling
nnoremap <Leader>m :w<cr>:make<cr>
nnoremap <Leader>c :cclose<cr>
nnoremap <Leader>n :cnext<cr>
nnoremap <Leader>p :cprev<cr>
autocmd QuickFixCmdPost [^l]* cwindow
au FileType qf call AdjustWindowHeight(1, 20)
function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width=winwidth(0)
    while l <= line('$')
        " number to float for division
        let l_len = strlen(getline(l)) + 0.0
        let line_width = l_len/w_width
        let n_lines += float2nr(ceil(line_width))
        let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" nvim tree
nnoremap <silent> <Leader>e :NvimTreeToggle<cr>

" terminal
tnoremap <Esc> <c-\><c-n>

" Function to reuse the same terminal
let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1

function! MonkeyTerminalOpen()
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves to the window the right the current one
    wincmd J
    resize 15
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

     " Change the name of the buffer to "Terminal 1"
     silent file Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
     let s:monkey_terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window below the current one
    wincmd J
    resize 15
    buffer Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
    endif
  endif
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
  else
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

nnoremap <Leader>j :call MonkeyTerminalToggle()<cr>i
tnoremap <Leader>j <C-\><C-n>:call MonkeyTerminalToggle()<cr>

" airline
let g:airline#extensions#tabline#formatter = 'unique_tail'

" better whitespaces
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
let g:strip_only_modified_lines = 1
let g:show_spaces_that_precede_tabs=1

" fugitive
set diffopt=vertical
nnoremap dgl :diffget //2<cr>
nnoremap dgr :diffget //3<cr>

" Tagbar
nnoremap <silent> <Leader>] :TagbarToggle<cr>
let g:tagbar_left = 1
set updatetime=200

" vim-rooter
let g:rooter_patterns = ['.git']

" termdebug
packadd termdebug
let g:termdebug_wide = 1

let mapleader = ","  " TODO: save/restore leader
nnoremap <leader>g :Gdb<cr>i
tnoremap <leader>s <c-\><c-n>:Source<cr>
nnoremap <leader>s :Source<cr>
tnoremap <leader>p <c-\><c-n>:Program<cr>
nnoremap <leader>p :Program<cr>
nnoremap <leader>b :Break<cr>
nnoremap <leader>r :Run<cr>
nnoremap <leader>d :Clear<cr>
nnoremap <leader>n :Over<cr>
nnoremap <leader>c :Continue<cr>
vnoremap <leader>e :'<,'>Evaluate<cr>
let mapleader = "\\"

" easymotion
map <space> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1

" quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=150

" nvim-tree
let g:nvim_tree_indent_markers = 1

" startify
let g:startify_session_persistence = 1
let g:startify_fortune_use_unicode = 1

" plugins
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
Plug 'yggdroot/indentline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'bogado/file-line'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'airblade/vim-rooter'
Plug 'mhinz/vim-startify'

Plug 'kyazdani42/nvim-tree.lua'

Plug 'easymotion/vim-easymotion'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

Plug 'nvim-lua/popup.nvim', { 'on': 'Telescope' }
Plug 'nvim-lua/plenary.nvim', { 'on': 'Telescope' }
Plug 'nvim-telescope/telescope.nvim', { 'on': 'Telescope' }

Plug 'unblevable/quick-scope'

Plug 'kyazdani42/nvim-web-devicons'

Plug 'jeffkreeftmeijer/vim-dim'
call plug#end()

colorscheme dim
hi debugPC gui=bold guifg=LightGray guibg=DarkCyan
hi debugBreakpoint gui=bold guibg=red guifg=white
hi NormalFloat gui=bold guibg=Brown

lua << EOF
require 'init'
EOF

inoremap <silent><expr> <cr>  compe#confirm('<cr>')

nnoremap <c-p> :Telescope find_files<cr>
nnoremap <c-l> :Telescope current_buffer_fuzzy_find<cr>
nnoremap <c-h> :Telescope oldfiles<cr>
nnoremap <Leader>gg :Telescope grep_string<cr>
nnoremap <Leader>lg :Telescope live_grep<cr>
nnoremap gco :Telescope git_branches<cr>
nnoremap gr :Telescope lsp_references<cr>
nnoremap gd :Telescope lsp_definitions<cr>
