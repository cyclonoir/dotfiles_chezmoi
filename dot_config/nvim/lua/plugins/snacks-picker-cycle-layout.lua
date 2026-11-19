return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        cycle_layout = function(picker)
          local presets = { "default", "vertical", "ivy", "telescope", "dropdown" }
          picker._layout_idx = (picker._layout_idx or 1) % #presets + 1
          local preset = presets[picker._layout_idx]
          picker:set_layout(preset)
          Snacks.notify(("%s  (%d/%d)"):format(preset, picker._layout_idx, #presets), {
            title = "Picker Layout",
            id = "snacks_picker_cycle_layout",
            timeout = 1500,
          })
        end,
      },
      win = {
        -- NOTE: <a-l> is swallowed by wezterm's AdjustPaneSize binding, so use <a-o>
        input = { keys = { ["<a-o>"] = { "cycle_layout", mode = { "i", "n" } } } },
        list = { keys = { ["<a-o>"] = "cycle_layout" } },
      },
    },
  },
}
