return {
  -- quickstart configs for nvim lsp
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

      vim.lsp.enable("ruby_lsp")
      vim.lsp.enable("gopls")
      vim.lsp.enable("templ")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf })

          if client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>cf", function()
              vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 500 })
            end, { buffer = ev.buf, desc = "Format buffer" })

            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false }),
              buffer = ev.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 500 })
              end,
            })
          end
        end,
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
