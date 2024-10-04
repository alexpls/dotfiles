return {
  -- quick navigation between buffers
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
      { "<leader>hn", function() require("harpoon"):list():next() end },
      { "<leader>h1", function() require("harpoon"):list():select(1) end },
      { "<leader>h2", function() require("harpoon"):list():select(2) end },
      { "<leader>h3", function() require("harpoon"):list():select(3) end },
      { "<leader>h4", function() require("harpoon"):list():select(4) end }
    },
  },
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
