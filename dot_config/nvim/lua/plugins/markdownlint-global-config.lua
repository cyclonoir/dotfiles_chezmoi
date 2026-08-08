return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        -- markdownlint-cli2 only discovers configs between the file and cwd,
        -- so ~/.markdownlint.jsonc is never found on its own; pass it as base.
        -- Project-local .markdownlint* files still apply on top.
        args = { "--config", vim.fn.expand("~/.markdownlint.jsonc") },
      },
    },
  },
}
