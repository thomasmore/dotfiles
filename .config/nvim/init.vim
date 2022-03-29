set nowrap
set number
set relativenumber
set signcolumn=yes:1
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal signcolumn=no
autocmd FileType dap-repl let b:lexima_disabled = 1

set scrolloff=5
set mouse=a
set inccommand=split

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

" searching
set hlsearch
set ignorecase
set smartcase
set incsearch

" compiling
nnoremap <silent> <leader>m :lua cmake_build()<cr>
nnoremap <leader>st :CMake select_target<cr>
nnoremap <leader>d :CMake debug<cr>
" nnoremap <leader>bd :CMake build_and_debug<cr>
nnoremap <leader>cl :cclose<cr>
nnoremap <leader>o :copen<cr>:cbottom<cr>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>p :cprev<cr>

" terminal
nnoremap <leader>vj :lua VertTermToggle()<cr>
tnoremap <leader>vj <c-\><c-n>:lua VertTermToggle()<cr>
nnoremap <leader>fj :lua FloatTermToggle()<cr>
tnoremap <leader>fj <c-\><c-n>:lua FloatTermToggle()<cr>

" better whitespaces
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
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
nnoremap <silent> <leader>c :lua require('dap').continue()<cr>
nnoremap <silent> <leader>n :lua require('dap').step_over()<cr>
nnoremap <silent> <leader>i :lua require('dap').step_into()<cr>
nnoremap <silent> <leader>f :lua require('dap').step_out()<cr>
nnoremap <silent> <leader>b :lua require('dap').toggle_breakpoint()<cr>
nnoremap <silent> <leader>B :lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
nnoremap <silent> <leader>l :lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>
nnoremap <silent> <leader>rc :lua require('dap').run_to_cursor()<cr>
nnoremap <silent> <leader>rl :lua require('dap').run_last()<cr>
vnoremap <leader>e :lua require("dapui").eval()<cr>
let mapleader = "\\"

" nvim-tree
let g:nvim_tree_indent_markers = 1
noremap <silent> <leader>e :NvimTreeToggle<cr>

" startify
let g:startify_session_persistence = 1
let g:startify_fortune_use_unicode = 1
let g:startify_lists = [
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'files',     'header': ['   MRU']            },
\ ]

" vim-notes
let g:notes_directories = [ '~/nvimnotes' ]

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
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'zeertzjq/nvim-paste-fix'
Plug 'Shatur/neovim-cmake'
Plug 'stevearc/dressing.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'cohama/lexima.vim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'SmiteshP/nvim-gps'
Plug 'folke/which-key.nvim'
Plug 'mrjones2014/legendary.nvim'

Plug 'jeffkreeftmeijer/vim-dim'
Plug 'folke/tokyonight.nvim'
call plug#end()

lua << EOF
require 'init'
EOF

colorscheme tokyonight
hi NormalFloat guifg=#c0caf5 guibg=#394060

xnoremap iu :lua require"treesitter-unit".select()<cr>
xnoremap au :lua require"treesitter-unit".select(true)<cr>
onoremap iu :<c-u>lua require"treesitter-unit".select()<cr>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<cr>

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
