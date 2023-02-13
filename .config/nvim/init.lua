-- TODO:
-- * disable autoindent for norg files
-- * <leader>wt doesn't work as intended
-- * less boilerplate in autcmd: pass pattern and callback as arguments
pcall(require, 'impatient')
require 'settings'
require 'plugins'
require 'mappings'
