require("opts")
require("keys")
require("lazy_init")

vim.filetype.add({
  extension = {
    -- neovim's default likes to set files ending with .html and containing
    -- curly braces to the htmlangular filetype, which doesn't work for me.
    -- Override it!
    -- https://github.com/neovim/neovim/blob/4e8efe002e976de1a22dcce6a1e800aeb6acad70/runtime/lua/vim/filetype/detect.lua#L728
    html = function(_, bufnr)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 1, 40, false)) do
        if vim.regex([[{{ .* }}]]):match_str(line) ~= nil then
          return "gohtmltmpl"
        else
          return "html"
        end
      end
    end
  },
})

-- Flash a highlight when text is yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
