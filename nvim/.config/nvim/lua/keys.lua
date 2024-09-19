vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<CR><C-l>")
vim.keymap.set("i", "<C-l>", "<cmd>nohlsearch<CR>")

-- Copy to system clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"*y')

-- Codeowners actions
vim.keymap.set("n", "<leader>co", require("codeowners").print)
