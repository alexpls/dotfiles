return {
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "-g", "!.git" },
      },
      extensions = {
        smart_open = {
          mappings = {
            i = {
              -- works around smart_open overriding ctrl-w keybind for deleting
              -- word. should be able to remove this once this issue is resolved:
              -- https://github.com/danielfalk/smart-open.nvim/issues/71
              ["<C-w>"] = function() vim.api.nvim_input("<c-s-w>") end,
            },
          },
        },
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
  -- telescope extension, sorts results by most relevant
  {
    "danielfalk/smart-open.nvim",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader><leader>",
        function()
          require("telescope").extensions.smart_open.smart_open()
        end
      },
    },
  }
}
