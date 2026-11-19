-- Windows only (see .chezmoiignore): on Linux, dev-setup's noctalia-theme.lua sets the colorscheme
-- and 'background' to match the desktop palette. This is what it picks for Noctalia's "Everforest"
-- palette in dark mode, so both look the same.

-- everforest picks its light or dark palette from this
vim.opt.background = "dark"

return {
  {
    "sainnhe/everforest",
    priority = 1000,
    init = function()
      vim.g.everforest_background = "hard"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
