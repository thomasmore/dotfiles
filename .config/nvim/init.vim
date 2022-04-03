autocmd FileType dap-repl let b:lexima_disabled = 1

" rg integration
nnoremap <leader>rg :silent lgrep<space>
nnoremap <silent> ]p :lprevious<cr>
nnoremap <silent> ]n :lnext<cr>
nnoremap <silent> ]o :lopen<cr>
nnoremap <silent> ]c :lclose<cr>

" highlight long lines
match ErrorMsg /\%121v.\+/

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

lua << EOF
require 'plugins'
require 'init'
require 'settings'
EOF

hi NormalFloat guifg=#c0caf5 guibg=#394060

xnoremap iu :lua require"treesitter-unit".select()<cr>
xnoremap au :lua require"treesitter-unit".select(true)<cr>
onoremap iu :<c-u>lua require"treesitter-unit".select()<cr>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<cr>

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * lua vim.highlight.on_yank()
augroup end
