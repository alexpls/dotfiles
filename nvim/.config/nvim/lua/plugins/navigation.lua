local cwd_for_telescope = function()
  local cwd = nil
  if vim.bo.filetype == "netrw" then
    cwd = vim.b.netrw_curdir
  else
    local current_file = vim.api.nvim_buf_get_name(0)
    cwd = vim.fn.fnamemodify(current_file, ":h")
  end
  return cwd
end

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
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" }
          })
        end
      },
      {
        -- Find sibling files to the currently open file, or find files in the
        -- current netrw window if that's open instead.
        -- Mnemonic: Find siBling Files
        "<leader>fbf",
        function()
          require("telescope.builtin").find_files({
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
            cwd = cwd_for_telescope(),
          })
        end
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").live_grep()
        end
      },
      -- Search sibling files to the currently open file, or search in the
      -- current netrw window if that's open instead.
      -- Mnemonic: Find siBling Search (really shoehorning this one...)
      {
        "<leader>fbs",
        function()
          require("telescope.builtin").live_grep({
            cwd = cwd_for_telescope(),
          })
        end
      },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").grep_string()
        end
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end
      },
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
          require("telescope").extensions.smart_open.smart_open {
            cwd_only = true,
          }
        end
      },
    },
  }
}
