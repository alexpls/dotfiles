return {
  -- syntax highlighting, treesitter!
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "javascript", "html", "css",
        "typescript", "ruby", "go", "markdown", "yaml",
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '<filetype>' },
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
}
