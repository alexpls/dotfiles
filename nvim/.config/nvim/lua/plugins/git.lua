return {
  -- git wrapper
  {
    "tpope/vim-fugitive",
    lazy = false,
    dependencies = {
      -- browse remotes (e.g. github)
      { "tpope/vim-rhubarb" },
    },
    keys = {
      -- Browse git remote
      { "<leader>gb", "<cmd>GBrowse<CR>" },
      { "<leader>gb", ":GBrowse<CR>",     mode = "v" },
      -- Copy git remote URL to clipboard
      { "<leader>gy", "<cmd>GBrowse!<CR>" },
      { "<leader>gy", ":GBrowse!<CR>",    mode = "v" }
    },
  },
  {
    -- adds gutter symbols for git added/modified/removed lines
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile", },
    config = true
  }
}
