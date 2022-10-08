require "luarocks.loader"

local Fmt = require('frmad.config.formats')

function logger()
	while true do
		local hout = io.open("/tmp/frmad.out", "w")
		for k, v in pairs(MTAB) do
			hout:write(k,': ', Fmt:formatvalue(k, v), "\n")
		end
		hout:close()
		coroutine.yield()
	end
end
return {co=logger, ri=2}
