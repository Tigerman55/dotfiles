local dap = require("dap")

local js_dbg_bin = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable = {
    command = js_dbg_bin,
    args = { "${port}" },
  },
}

