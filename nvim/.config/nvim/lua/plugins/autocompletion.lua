return {
  -- snippet & LSP autocompletion
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },
  {
    "saghen/blink.cmp",
    version = '1.*',
    dependencies = {
      { "L3MON4D3/LuaSnip" },
    },
    opts = {
      keymap = {
        preset = 'default',
        ['<Enter>'] = { 'accept', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
      },
      completion = { documentation = { auto_show = false } },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
}
