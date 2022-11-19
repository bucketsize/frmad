require "luarocks.loader"

local Fmt = require('frmad.config.formats')

-- Log to stdout --
function logger()
	local h = io.open("/var/tmp/frmad.log.json", "a")
	while true do
		h:write("{")
		for k, v in pairs(MTAB) do
			if type(v) == "string" then
				h:write(string.format("\"%s\":\"%s\",", k, v))
			else
				h:write(string.format("\"%s\":%s,", k, v))
			end
		end
		h:write("\"__e\":1}\n")
		coroutine.yield()
	end
	h:close()
end
return {co=logger, ri=2}
