return {
  -- pretty colour scheme
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
    config = function()
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.cmd.colorscheme(vim.o.background == "dark" and "tokyonight" or "tokyonight-day")
    end,
  },
}
