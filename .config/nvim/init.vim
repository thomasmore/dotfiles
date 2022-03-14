set nowrap
set number
set relativenumber
set signcolumn=yes:1
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal signcolumn=no

set scrolloff=5
set mouse=a
set inccommand=split

noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

inoremap jj <esc>
inoremap jw <esc>:w<cr>
inoremap jq <esc>:wq<cr>

set clipboard+=unnamedplus

" rg integration
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m,%f:%l:%m
nnoremap <leader>rg :silent lgrep<space>
nnoremap <silent> ]p :lprevious<cr>
nnoremap <silent> ]n :lnext<cr>
nnoremap <silent> ]o :lopen<cr>
nnoremap <silent> ]c :lclose<cr>

" windows layout
set winheight=20
set winminwidth=15
set winminheight=5

" folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=10

" reserve gd/gD to lsp-related things
nnoremap Gd gd
nnoremap GD gD
" go to bottom without irritating delay
nnoremap GG G

" indent-blankline
let g:indent_blankline_char ='▏'
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_first_indent_level = v:false
let g:indent_blankline_filetype_exclude = ['json', 'startify']
let g:indent_blankline_buftype_exclude = ['terminal']

" highlight long lines
match ErrorMsg /\%121v.\+/

" open at last edit
au BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" split to below and right
set splitbelow
set splitright

nnoremap <M-right> <C-w>l
nnoremap <M-l> <C-w>l
nnoremap <M-left> <C-w>h
nnoremap <M-h> <C-w>h
nnoremap <M-up> <C-w>k
nnoremap <M-k> <C-w>k
nnoremap <M-down> <C-w>j
nnoremap <M-j> <C-w>j

" searching
set hlsearch
nnoremap <f2> :nohlsearch<cr>
set ignorecase
set smartcase
set incsearch

" linting/compiling
nnoremap <leader>m :w<cr>:make<cr>
nnoremap <leader>c :cclose<cr>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>p :cprev<cr>

" terminal
nnoremap <leader>vj :lua VertTermToggle()<cr>
tnoremap <leader>vj <c-\><c-n>:lua VertTermToggle()<cr>
nnoremap <leader>fj :lua FloatTermToggle()<cr>
tnoremap <leader>fj <c-\><c-n>:lua FloatTermToggle()<cr>

" better whitespaces
let g:better_whitespace_enabled = 1
" TODO: enable when fixed
"let g:strip_whitespace_on_save = 1
let g:strip_only_modified_lines = 1
let g:show_spaces_that_precede_tabs=1

" fugitive
set diffopt=vertical
nnoremap dgl :diffget //2<cr>
nnoremap dgr :diffget //3<cr>

" vim-rooter
let g:rooter_patterns = ['.git']
let g:rooter_silent_chdir = 1

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

" nvim-tree
let g:nvim_tree_indent_markers = 1
noremap <silent> <leader>e :NvimTreeToggle<cr>

" startify
let g:startify_session_persistence = 1
let g:startify_fortune_use_unicode = 1

" plugins
call plug#begin()
Plug 'hoob3rt/lualine.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'bogado/file-line'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'airblade/vim-rooter'
Plug 'mhinz/vim-startify'
Plug 'b3nj5m1n/kommentary'
Plug 'karb94/neoscroll.nvim'
Plug 'akinsho/nvim-toggleterm.lua'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

Plug 'rafamadriz/friendly-snippets'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'David-Kunz/treesitter-unit'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ggandor/lightspeed.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'alvarosevilla95/luatab.nvim'

Plug 'michaeljsmith/vim-indent-object'
Plug 'chaoren/vim-wordmotion'
Plug 'wellle/targets.vim'

Plug 'Pocco81/AutoSave.nvim'

Plug 'tanvirtin/vgit.nvim'
Plug 'cohama/lexima.vim'

Plug 'jeffkreeftmeijer/vim-dim'
Plug 'folke/tokyonight.nvim'
call plug#end()

lua << EOF
require 'init'
EOF

colorscheme tokyonight
hi debugPC cterm=bold ctermfg=white ctermbg=darkcyan gui=bold guifg=white guibg=darkcyan
hi debugBreakpoint cterm=bold ctermfg=white ctermbg=red gui=bold guibg=red guifg=white
hi NormalFloat guifg=#c0caf5 guibg=#394060

nnoremap <c-p> :Telescope find_files<cr>
nnoremap <c-l> :Telescope current_buffer_fuzzy_find<cr>
nnoremap <c-h> :Telescope oldfiles<cr>
nnoremap <leader>gg :Telescope grep_string<cr>
nnoremap <leader>lg :Telescope live_grep<cr>
nnoremap <leader>fb :Telescope file_browser<cr>
nnoremap <leader>bu :Telescope buffers<cr>
nnoremap gco :Telescope git_branches<cr>
nnoremap gr :Telescope lsp_references<cr>
nnoremap gd :Telescope lsp_definitions<cr>
nnoremap <c-RightMouse> <LeftMouse>:Telescope lsp_definitions<cr>

xnoremap iu :lua require"treesitter-unit".select()<cr>
xnoremap au :lua require"treesitter-unit".select(true)<cr>
onoremap iu :<c-u>lua require"treesitter-unit".select()<cr>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<cr>

nnoremap <leader>gu :VGit hunk_up<cr>
nnoremap <leader>gd :VGit hunk_down<cr>
nnoremap <leader>gr :VGit buffer_hunk_reset<cr>
nnoremap <leader>gv :VGit buffer_hunk_preview<cr>
