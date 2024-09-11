-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true     -- show line numbers
vim.opt.scrolloff = 10    -- num screen lines to show above/below cursor
vim.opt.undofile = true   -- persist undo history to file
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 1000 -- after this many seconds without input, save swap file
vim.opt.timeoutlen = 300

-- Leader key mapping
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw config
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 50

-- Highlight search results
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<CR><C-l>")
vim.keymap.set("i", "<C-l>", "<cmd>nohlsearch<CR>")

-- Copy to system clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"*y')

-- Codeowners actions
vim.keymap.set("n", "<leader>co", require("codeowners").print)

vim.filetype.add({
  extension = {
    -- neovim's default likes to set files ending with .html and containing
    -- curly braces to the htmlangular filetype, which doesn't work for me.
    -- Override it!
    -- https://github.com/neovim/neovim/blob/4e8efe002e976de1a22dcce6a1e800aeb6acad70/runtime/lua/vim/filetype/detect.lua#L728
    html = function(_, bufnr)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 1, 40, false)) do
        if vim.regex([[{{ .* }}]]):match_str(line) ~= nil then
          return "gohtmltmpl"
        else
          return "html"
        end
      end
    end
  },
})

-- Flash a highlight when text is yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local plugins = {
  -- heuristically set buffer options (e.g. shiftwidth, expandtab)
  { "tpope/vim-sleuth" },
  -- git wrapper
  {
    "tpope/vim-fugitive",
    config = function()
      -- Browse git remote
      vim.keymap.set("n", "<leader>gb", "<cmd>GBrowse<CR>")
      vim.keymap.set("v", "<leader>gb", ":GBrowse<CR>")
      -- Copy git remote URL to clipboard
      vim.keymap.set("n", "<leader>gy", "<cmd>GBrowse!<CR>")
      vim.keymap.set("v", "<leader>gy", ":GBrowse!<CR>")
    end,
  },
  -- github extension for vim-fugitive
  { "tpope/vim-rhubarb" },
  -- quickstart configs for nvim lsp
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lsp = require "lspconfig"
      local lsp_zero = require "lsp-zero"

      local lsp_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        lsp_zero.default_keymaps({ buffer = bufnr })
        vim.keymap.set("n", "<leader>ca", "<cmd>vim.lsp.buf.code_action()<CR>", opts)
        lsp_zero.buffer_autoformat()
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      lsp.elixirls.setup {
        cmd = { "/opt/homebrew/bin/elixir-ls" },
      }
      lsp.gopls.setup {}
      lsp.ts_ls.setup {}
      lsp.ruby_lsp.setup {}
      lsp.tailwindcss.setup {}
      lsp.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT"
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library"
              }
            }
          })
        end,
        settings = {
          Lua = {},
        },
      }
    end
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    lazy = true,
    config = false,
  },
  -- source completions from lsp
  { "hrsh7th/cmp-nvim-lsp" },
  -- compeltions engine
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({}),
      })
    end
  },
  -- track time spent in editor
  { "wakatime/vim-wakatime", lazy = false },
  -- make splits work across nvim and its host terminal
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      local ss = require("smart-splits")
      vim.keymap.set("n", "<C-w>+", ss.resize_up)
      vim.keymap.set("n", "<C-w>-", ss.resize_down)
      vim.keymap.set("n", "<C-w><", ss.resize_left)
      vim.keymap.set("n", "<C-w>>", ss.resize_right)
      vim.keymap.set("n", "<C-w>h", ss.move_cursor_left)
      vim.keymap.set("n", "<C-w>j", ss.move_cursor_down)
      vim.keymap.set("n", "<C-w>k", ss.move_cursor_up)
      vim.keymap.set("n", "<C-w>l", ss.move_cursor_right)
    end
  },
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


      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.cmd.colorscheme(vim.o.background == "dark" and "tokyonight" or "tokyonight-day")
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
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.git_files)
      vim.keymap.set("n", "<leader>fp", builtin.find_files)
      vim.keymap.set("n", "<leader>fs", builtin.live_grep)
      vim.keymap.set("n", "<leader>fd", builtin.grep_string)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end
  },
  -- quick navigation between buffers
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)
    end
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
    ft = { "go", "gomod", "gohtmltmpl" },
    build = ':lua require("go.install").update_all_sync()'
  },
}

require("lazy").setup(plugins, {})
