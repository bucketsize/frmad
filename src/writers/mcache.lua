require "luarocks.loader"

local Fmt = require('frmad.formats')
local cachec = require("frmad.cachec")

function mcache()
   while true do
	  for i,k in Fmt:ipairs() do
		 local v = MTAB[k]
		 local s, st = cachec:put(k, v, type(v))
		 if not (s == "ok") then
			print("error: mcache", k, v, type(v), s, st)
		 end
	  end
	  coroutine.yield()
   end
end
return {co=mcache, ri=2}
