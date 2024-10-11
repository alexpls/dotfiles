return {
  -- make splits work across nvim and its host terminal
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      { "<C-w>+", function() require("smart-splits").resize_up() end },
      { "<C-w>-", function() require("smart-splits").resize_down() end },
      { "<C-w><", function() require("smart-splits").resize_left() end },
      { "<C-w>>", function() require("smart-splits").resize_right() end },
      { "<C-w>h", function() require("smart-splits").move_cursor_left() end },
      { "<C-w>j", function() require("smart-splits").move_cursor_down() end },
      { "<C-w>k", function() require("smart-splits").move_cursor_up() end },
      { "<C-w>l", function() require("smart-splits").move_cursor_right() end }
    },
  },
}
