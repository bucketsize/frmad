require "luarocks.loader"

local Fmt = require('frmad.config.formats')

-- Log to stdout --
function logger()
	while true do
		for k, v in pairs(MTAB) do
			io.write(Fmt:formatvalue(k, v), ",")
		end
		io.write("\n")
		coroutine.yield()
	end
end
return {co=logger, ri=2}
