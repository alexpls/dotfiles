vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.showmode = false
vim.opt.scrolloff = 10
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch</cmd>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
  {"tpope/vim-sleuth"},
  {
    "folke/tokyonight.nvim",
    config = function ()
      require("tokyonight").setup({
        transparent = true,
        terminal_colors = true,
	styles = {
		sidebars = "dark",
		floats = "dark",
	},
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
	      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "css", "elixir", "heex", "typescript", "ruby", "go" },
	      sync_install = true,
	      highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
            },
          },
        },
      })
    end,
  },
  {"nvim-treesitter/nvim-treesitter-textobjects"},
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
  },
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/nvim-cmp"},
  {"L3MON4D3/LuaSnip"},
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {"wakatime/vim-wakatime", lazy = false},
}

opts = {}

require("lazy").setup(plugins, opts)

function in_git_dir()
  return vim.fn.system("git rev-parse --is-inside-work-tree") == "true"
end

vim.cmd[[colorscheme tokyonight]]
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
 
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function ()
  if in_git_dir() then
    builtin.git_files()
  else
    builtin.find_files()
  end
end)
vim.keymap.set("n", "<leader>fs", builtin.live_grep)
vim.keymap.set("n", "<leader>fd", builtin.grep_string)

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
  lsp_zero.buffer_autoformat()
end)

require'lspconfig'.gopls.setup{}
require'lspconfig'.tsserver.setup{}

vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)

