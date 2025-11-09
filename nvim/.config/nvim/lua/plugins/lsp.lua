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

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf })
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
