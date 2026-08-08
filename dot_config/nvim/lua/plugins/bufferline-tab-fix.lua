-- When a colorscheme defines no BufferLine* highlight groups, bufferline
-- derives its own: tab_selected.fg from TabLineSel.bg, and tab_selected.bg from
-- Normal.bg. In themes where those two colours are near-identical -- gruvbox
-- and rose-pine both are -- the selected tab's label becomes invisible.
--
-- A pinned replacement colour would only ever suit the theme it was chosen for,
-- so instead measure the contrast the active theme actually produces and step
-- in only when it falls below a legibility threshold, borrowing an accent the
-- theme itself defines.
--
-- opts.highlights may be a function. bufferline calls it with freshly derived
-- defaults, and calls it again on every ColorScheme event
-- (update_highlights -> setup -> Config:resolve), so this re-evaluates per
-- theme without needing an autocmd of its own. resolve() runs before merge(),
-- so returning a partial table is enough: keys left out keep the theme's
-- own values.

local MIN_CONTRAST = 3.0 -- WCAG ratio for large/bold UI text

---@return number?, number?, number?
local function to_rgb(hex)
  if type(hex) ~= "string" then return nil end
  local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
  if not r then return nil end
  return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

---Relative luminance per WCAG 2.x
---@return number?
local function luminance(hex)
  local r, g, b = to_rgb(hex)
  if not r then return nil end
  local function channel(c)
    c = c / 255
    return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
end

---@return number? ratio between 1 and 21, or nil if either colour is unresolvable
local function contrast(a, b)
  local la, lb = luminance(a), luminance(b)
  if not la or not lb then return nil end
  if la < lb then
    la, lb = lb, la
  end
  return (la + 0.05) / (lb + 0.05)
end

---@return string? hex foreground of a highlight group, following links
local function group_fg(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or not hl or not hl.fg then return nil end
  return ("#%06x"):format(hl.fg)
end

-- Ordered by how much they read as an "accent", ending in Normal, whose fg is
-- legible against Normal.bg by definition and so acts as a guaranteed fallback.
local CANDIDATES = { "Function", "String", "Identifier", "Special", "Directory", "Normal" }

return {
  "akinsho/bufferline.nvim",
  opts = {
    highlights = function(defaults)
      local default_tab = defaults.highlights.tab_selected
      local bg, fg = default_tab.bg, default_tab.fg

      local current = contrast(fg, bg)
      if current and current >= MIN_CONTRAST then
        return {} -- the theme's own colours are legible; leave them alone
      end

      local best, best_ratio = nil, current or 0
      for _, group in ipairs(CANDIDATES) do
        local candidate = group_fg(group)
        local ratio = candidate and contrast(candidate, bg)
        if ratio and ratio > best_ratio then
          best, best_ratio = candidate, ratio
          if ratio >= MIN_CONTRAST then break end
        end
      end

      if not best then return {} end -- nothing resolvable (e.g. bg is "NONE")
      return { tab_selected = { fg = best } }
    end,
  },
}
