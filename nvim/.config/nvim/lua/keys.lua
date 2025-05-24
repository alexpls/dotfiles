vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<CR><C-l>")
vim.keymap.set("i", "<C-l>", "<cmd>nohlsearch<CR>")

-- Copy to system clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')

-- Codeowners actions
vim.keymap.set("n", "<leader>co", require("codeowners").print)

-- Open diagnostic
vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float)

-- Copy current filepath to system clipboard. This is relative
-- to the project's root.
-- Mnemonic: File Yank
vim.keymap.set("n", "<leader>fy", function()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath)
  vim.notify("Filepath copied to clipboard: " .. filepath, vim.log.levels.INFO)
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>t", "<cmd>!go test ./...<CR>")
  end
})
