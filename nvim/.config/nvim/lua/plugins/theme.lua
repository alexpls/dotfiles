return {
  -- pretty colour scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
      })

      vim.cmd.colorscheme(vim.o.background == "dark" and "tokyonight" or "tokyonight-day")
    end,
  },
}
