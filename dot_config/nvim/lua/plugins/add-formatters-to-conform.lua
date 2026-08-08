return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
    },
    formatters = {
      csharpier = {
        command = "csharpier",
        args = function(self, ctx)
          return { "format", "--write-stdout", "--stdin-path", ctx.filename }
        end,
        stdin = true,
      },
      prettier = {
        -- editor-global defaults; project .prettierrc still wins via file-override
        prepend_args = { "--prose-wrap", "always", "--print-width", "80", "--config-precedence", "file-override" },
      },
    },
  },
}
