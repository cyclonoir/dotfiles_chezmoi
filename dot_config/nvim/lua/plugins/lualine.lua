-- declutter the statusline: filename only (no path), no root_dir,
-- and breadcrumbs limited to type containers
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    -- The lualine theme for the current colorscheme (its own, else one built from its
    -- highlights), with section c pinned to one bg: trouble bakes lualine_c_normal's bg
    -- into its highlight groups, but themes like gruvbox's change c's bg per mode.
    -- Theme modules are reloaded each time, since some read the colorscheme's palette
    -- when loaded.
    local function theme()
      local function load(name)
        package.loaded[name] = nil
        return require(name)
      end
      local ok, t = pcall(load, "lualine.themes." .. (vim.g.colors_name or ""))
      t = vim.deepcopy(ok and t or load("lualine.themes.auto"))
      for _, mode in pairs(t) do
        mode.c = t.normal.c
      end
      return t
    end
    opts.options.theme = theme()

    -- A theme table doesn't follow later colorscheme changes (on Linux, Noctalia
    -- switches them while Neovim runs), so rebuild it on each one.
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("lualine_follow_colorscheme", { clear = true }),
      callback = function()
        local config = require("lualine").get_config()
        config.options.theme = theme()
        require("lualine").setup(config)
      end,
    })

    -- breadcrumbs: type containers only, no methods/properties
    -- (LazyVim's own version is off via vim.g.trouble_lualine = false)
    local symbols = require("trouble").statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = {
        range = true,
        kind = { "Namespace", "Class", "Interface", "Struct", "Enum" },
      },
      format = "{kind_icon}{symbol.name:Normal}",
      hl_group = "lualine_c_normal",
    })

    -- lualine's branch component searches upward for .git joining paths with a
    -- hardcoded \ on Windows, so it finds nothing when the buffer path uses forward
    -- slashes (picker / LSP jumps). gitsigns resolves the repo via git itself.
    opts.sections.lualine_b = {
      { function() return vim.b.gitsigns_head or "" end, icon = "" },
    }

    opts.sections.lualine_c = {
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        "filename",
        path = 0,
        symbols = { modified = "●", readonly = "󰌾", unnamed = "", newfile = "" },
      },
      {
        -- trouble emits %* after each segment, which resets to StatusLine's bg and
        -- leaves its separator/trailing spaces a different color. Reset to section c.
        function()
          return (symbols.get():gsub("%%%*", "%%#lualine_c_normal#"))
        end,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      },
    }

    -- drops LazyVim's snacks profiler, noice cmdline (showcmd) and dap components
    opts.sections.lualine_x = {
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      -- stylua: ignore
      {
        function() return require("noice").api.status.mode.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        color = function() return { fg = Snacks.util.color("Constant") } end,
      },
      -- stylua: ignore
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = function() return { fg = Snacks.util.color("Special") } end,
      },
      {
        "diff",
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    }
  end,
}
