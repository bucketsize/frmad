require "luarocks.loader"

local cachec = require("frmad.lib.cachec")

return {co=function()
	while true do
		for k, v in pairs(MTAB) do
			local s, st = cachec:put(k, v, type(v))
			if not (s == "ok") then
				print("error: mcache", k, v, type(v), s, st)
			end
		end
		coroutine.yield()
	end
end
, ri=2}
