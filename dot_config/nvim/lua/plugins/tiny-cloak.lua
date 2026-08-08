return {
  "jellydn/tiny-cloak.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    cloak_character = "*",
    file_patterns = { ".env*", "*.json", "*.yaml", "*.yml" },
    -- NOTE: .env matching is anchored to line start + case-sensitive (string.find(line, "^"..pattern)),
    -- so each key must be listed by its literal prefix. COCO_* keys added for fetch-coco-comments/.env.
    key_patterns = {
      "API_KEY", "SECRET", "PASSWORD", "TOKEN", "CREDENTIAL", "AUTH",
      "COCO_USERNAME", "COCO_PASSWORD",
    },
  },
  keys = {
    { "<leader>ct", "<cmd>CloakToggle<cr>", desc = "Toggle cloak" },
    { "<leader>cp", "<cmd>CloakPreviewToggle<cr>", desc = "Preview cloak line" },
  },
}
