return {
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "-g", "!.git" },
      },
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } }) end },
      { "<leader>fg", function() require("telescope.builtin").git_status() end },
      { "<leader>fs", function() require("telescope.builtin").live_grep() end },
      { "<leader>fd", function() require("telescope.builtin").grep_string() end },
      { "<leader>fb", function() require("telescope.builtin").buffers() end },
    },
  },
}
