return {
  "seblyng/roslyn.nvim",
  -- set by `git mergetool` (see ~/.gitconfig) to skip roslyn's slow startup
  cond = not vim.g.git_mergetool,
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {},
}
