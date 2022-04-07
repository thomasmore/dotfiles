-- autocmd FileType dap-repl let b:lexima_disabled = 1

-- " terminal
-- nnoremap <leader>vj :lua VertTermToggle()<cr>
-- tnoremap <leader>vj <c-\><c-n>:lua VertTermToggle()<cr>
-- nnoremap <leader>fj :lua FloatTermToggle()<cr>
-- tnoremap <leader>fj <c-\><c-n>:lua FloatTermToggle()<cr>

-- nnoremap dgl :diffget //2<cr>
-- nnoremap dgr :diffget //3<cr>

-- vnoremap ,e :lua require("dapui").eval()<cr>

require 'before'
require 'plugins'
require 'impatient'
require 'after'
require 'settings'
require 'mappings'

-- xnoremap iu :lua require"treesitter-unit".select()<cr>
-- xnoremap au :lua require"treesitter-unit".select(true)<cr>
-- onoremap iu :<c-u>lua require"treesitter-unit".select()<cr>
-- onoremap au :<c-u>lua require"treesitter-unit".select(true)<cr>

-- imap <silent><script><expr> <m-j> copilot#Accept()
