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
}
