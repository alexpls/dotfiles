vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.scrolloff = 10        -- num screen lines to show above/below cursor
vim.opt.colorcolumn = "80"    -- vertical marker at 80 cols
vim.opt.undofile = true       -- persist undo history to file
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 1000     -- after this many seconds without input, save swap file
vim.opt.timeoutlen = 300

-- Tabs & spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Leader key mapping
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw config
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 50

-- Search result highlighting
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
