require "luarocks.loader"

local Fmt = require('frmad.config.formats')

return {co=function ()
	while true do
		local hout = assert(io.open("/tmp/frmad.out", "w"))
		for k, v in pairs(MTAB) do
			hout:write(k,': ', Fmt:formatvalue(k, v), "\n")
		end
		hout:close()
		coroutine.yield()
	end
end, ri=2}
