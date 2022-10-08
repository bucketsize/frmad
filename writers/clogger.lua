require "luarocks.loader"

local Fmt = require('frmad.config.formats')

-- Log to stdout --
function logger()
	while true do
		io.write("{")
		for k, v in pairs(MTAB) do
			io.write(k, ": ", Fmt:formatvalue(k, v), ",")
		end
		io.write("end: 1}\n")
		coroutine.yield()
	end
end
return {co=logger, ri=2}
