return {
  -- easy LSP config
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    lazy = true,
    config = false,
  },
  -- easy install lang servers
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  -- quickstart configs for nvim lsp
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      local lsp_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        lsp_zero.default_keymaps(opts)
        lsp_zero.buffer_autoformat()

        vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      })

      local lspconfig = require('lspconfig')
      lspconfig.ruby_lsp.setup({
        init_options = {
          formatter = 'rubocop',
          linters = { 'rubocop' },
        }
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({})
          end,

          lua_ls = function()
            require("lspconfig").lua_ls.setup({
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
                      "${3rd}/luv/library",
                      vim.env.HOME .. "/.hammerspoon/Spoons/EmmyLua.spoon/annotations",
                    }
                  }
                })
              end,
              settings = {
                Lua = {},
              },
            })
          end,
        }
      })
    end
  },
  -- go goodies
  {
    "ray-x/go.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gohtmltmpl" },
    build = ':lua require("go.install").update_all_sync()'
  },
}
