require("luarocks.loader")

return {
	co = function()
		local user = os.getenv("USER")
		local h = assert(io.open("/var/tmp/frmad.log.json." .. user, "a"))
		while true do
			h:write("{")
			for k, v in pairs(MTAB) do
				if type(v) == "string" then
					h:write(string.format('"%s":"%s",', k, v))
				else
					h:write(string.format('"%s":%s,', k, v))
				end
			end
			h:write('"__e":1}\n')
			coroutine.yield()
		end
	end,
	ri = 2,
}
