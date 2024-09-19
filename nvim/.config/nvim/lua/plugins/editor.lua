return {
  -- heuristically set buffer options (e.g. shiftwidth, expandtab)
  { "tpope/vim-sleuth" },
  -- track time spent in editor
  { "wakatime/vim-wakatime", lazy = false },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle }
    }
  }
}
