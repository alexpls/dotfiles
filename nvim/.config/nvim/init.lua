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
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
-- Copy to system clipboard
vim.keymap.set("n", "<leader>y", '"*y')
vim.keymap.set("x", "<leader>y", '"*y')

vim.filetype.add({
  extension = {
    -- neovim's default likes to set files ending with .html and containing
    -- curly braces to the htmlangular filetype, which doesn't work for me.
    -- Override it!
    -- https://github.com/neovim/neovim/blob/4e8efe002e976de1a22dcce6a1e800aeb6acad70/runtime/lua/vim/filetype/detect.lua#L728
    html = function(_, bufnr)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 1, 40, false)) do
        if vim.regex([[{{ .* }}]]):match_str(line) ~= nil then
          return 'gohtmltmpl'
        else
          return 'html'
        end
      end
    end
  },
})

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

local plugins = {
  -- heuristically set buffer options (e.g. shiftwidth, expandtab)
  { "tpope/vim-sleuth" },
  -- git wrapper
  { "tpope/vim-fugitive" },
  -- github extension for vim-fugitive
  { "tpope/vim-rhubarb" },
  -- quickstart configs for nvim lsp
  { "neovim/nvim-lspconfig" },
  -- source completions from lsp
  { "hrsh7th/cmp-nvim-lsp" },
  -- compeltions engine
  { "hrsh7th/nvim-cmp" },
  -- track time spent in editor
  { "wakatime/vim-wakatime",        lazy = false },
  -- make splits work across nvim and its host terminal
  { 'mrjones2014/smart-splits.nvim' },
  -- pretty colour scheme
  {
    "folke/tokyonight.nvim",
    config = function()
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
  -- syntax highlighting, objects, treesitter!
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "css", "elixir", "heex", "typescript", "ruby", "go", "markdown", },
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
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
  -- textobjects for treesitter, to help with selecting ruby blocks
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- easier lsp configuration
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
  },
  -- quick navigation between buffers
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  -- go goodies
  {
    "ray-x/go.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { 'go', 'gomod', 'gohtmltmpl' },
    build = ':lua require("go.install").update_all_sync()'
  },
  -- ui component library
  {
    "MunifTanjim/nui.nvim",
  },
  -- file tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        hijack_netrw_behavior = "open_default",
      })
    end,
  },
}

require("lazy").setup(plugins, {})

vim.cmd.colorscheme(vim.o.background == 'dark' and 'tokyonight' or 'tokyonight-day')
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.git_files)
vim.keymap.set("n", "<leader>fp", builtin.find_files)
vim.keymap.set("n", "<leader>fs", builtin.live_grep)
vim.keymap.set("n", "<leader>fd", builtin.grep_string)
vim.keymap.set("n", "<leader>fb", builtin.buffers)

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
  lsp_zero.buffer_autoformat()
end)

require 'lspconfig'.elixirls.setup {
  cmd = { "/opt/homebrew/bin/elixir-ls" },
}
require 'lspconfig'.gopls.setup {}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.ruby_lsp.setup {}
require 'lspconfig'.tailwindcss.setup {}
require 'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {},
  },
}


local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)

vim.keymap.set('n', '<C-w>+', require('smart-splits').resize_up)
vim.keymap.set('n', '<C-w>-', require('smart-splits').resize_down)
vim.keymap.set('n', '<C-w><', require('smart-splits').resize_left)
vim.keymap.set('n', '<C-w>>', require('smart-splits').resize_right)
vim.keymap.set('n', '<C-w>h', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-w>j', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-w>k', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-w>l', require('smart-splits').move_cursor_right)

require("codeowners")

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

vim.keymap.set("n", "<leader>co", codeowners.print)
vim.keymap.set("n", "<leader>pe", vim.cmd.Ex)

vim.keymap.set("n", "<leader>bb", "<cmd>Neotree toggle<CR>")
