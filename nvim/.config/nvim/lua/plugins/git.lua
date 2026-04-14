return {
  -- git wrapper
  {
    "tpope/vim-fugitive",
    lazy = false,
    dependencies = {
      -- browse remotes (e.g. github)
      { "tpope/vim-rhubarb" },
    },
    config = function()
      -- TODO: hack. Remove once the underlying issue is fixed:
      -- https://github.com/tpope/vim-fugitive/issues/2441
      vim.api.nvim_create_user_command("Browse", function(opts)
        vim.fn.system({ "open", opts.fargs[1] })
      end, { nargs = 1 })
    end,
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
