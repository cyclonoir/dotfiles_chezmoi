-- App-specific window rules. Loaded after Omarchy's defaults, so rules here
-- override the stock ones in $OMARCHY_PATH/default/hypr/apps/.
local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

require_all.files(paths.config_home .. "/hypr/apps", "hypr.apps")
