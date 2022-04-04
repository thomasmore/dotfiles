autocmd FileType dap-repl let b:lexima_disabled = 1

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

vnoremap ,e :lua require("dapui").eval()<cr>

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

xnoremap iu :lua require"treesitter-unit".select()<cr>
xnoremap au :lua require"treesitter-unit".select(true)<cr>
onoremap iu :<c-u>lua require"treesitter-unit".select()<cr>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<cr>
