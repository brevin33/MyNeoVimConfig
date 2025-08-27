-- prelazy
vim.g.copilot_no_tab_map = true
vim.g.copilot_enabled = false

require("core.lazy")
require("core.keymap")
require("core.set")
require("core.setup")

--vim.opt_local.formatoptions:remove({ "r", "o" })
