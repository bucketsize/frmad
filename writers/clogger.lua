require "luarocks.loader"

local Fmt = require('frmad.config.formats')

-- Log to stdout --
function logger()
	while true do
		local ll = ""
		for i,k in Fmt:ipairs() do
			local fmt = Fmt[k]
			local v = MTAB[k]
			ll = ll .. string.format(fmt, v) ..  ","
		end
		print(ll)
		coroutine.yield()
	end
end
return {co=logger, ri=2}
