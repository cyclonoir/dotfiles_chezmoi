-- Windows only (see .chezmoiignore): on Linux, dev-setup's noctalia-theme.lua sets the colorscheme
-- and 'background' to match the desktop palette.

-- gruvbox.nvim picks its light or dark palette from this
vim.opt.background = "dark"

return {

  { "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 1000, opts = { contrast = "soft" } },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
