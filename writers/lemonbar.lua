#!/usr/bin/env lua
require("luarocks.loader")

local sym = require("frmad.lib.sym").ascii
local processmetrics = require("frmad.lib.process_metrics")

local function statusline()
	local metrics = processmetrics()
	return string.format(
		"%%{l} %s%s %%{c}...%%{r} %s%s %s%s | %s %s%s | %s%s | %s%s | %s%s | %s%s\n",
		sym["clock"],
		os.date("%a %b %d, %Y | %H:%M:%S"),
		metrics.cpu.sym,
		metrics.cpu.val,
		metrics.cpu_temp.sym,
		metrics.cpu_temp.val,
		metrics.gpu.sym,
		metrics.cpu_temp.sym,
		metrics.gpu.val,
		metrics.mem.sym,
		metrics.mem.val,
		metrics.audio.sym,
		metrics.audio.val,
		metrics.net.sym,
		metrics.net.val,
		metrics.bat.sym,
		metrics.bat.val
	)
end

return {
	co = function()
		local user = os.getenv("USER")
		while true do
			local hout = assert(io.open("/tmp/frmad.lemonbar.out." .. user, "w"))
			hout:write(statusline())
			hout:close()
			coroutine.yield()
		end
	end,
	formatter = statusline,
	ri = 2,
}
