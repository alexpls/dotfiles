return {
  -- syntax highlighting, treesitter!
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local filetypes = {
        "lua", "vim", "vimdoc", "javascript", "html", "css",
        "typescript", "ruby", "go", "markdown", "yaml", "templ",
      }

      require("nvim-treesitter").install(filetypes)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
}
