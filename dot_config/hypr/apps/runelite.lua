-- RuneLite spawns floating helper windows (win1, win2, ...) that steal focus.
o.window(
  { class = "net-runelite-client-RuneLite", title = "^(win\\d+)$", float = true },
  { no_focus = true }
)

-- Keep the game fully opaque.
o.window({ title = "^(RuneLite.*)$" }, { opacity = "1 1" })
