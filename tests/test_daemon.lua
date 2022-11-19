#!/usr/bin/env lua
package.path = '?.lua;' .. package.path
require "luarocks.loader"
luaunit = require('luaunit')

local Al = require("config.alerts")
local json = require("minilib.json")

function test_01fragments()
   for k,v in ipairs({"amdgpu","battery","cpu","cpu_freq","cpu_temp","disk","mem","net","process","pulseaudio", "weather"}) do
	  local f = require("frmad.fragments." .. v)
      local r = f.fn()
      if type(r) == "table" then
          print(v..":", json.encode(r))
      else
          print(v..":", r)
      end
   end
end

function test_02alerts()
	for i=1,45 do
		assert(Al.check('cpu', 80))
		assert(Al.check('cpu_temp', 80))
		assert(Al.check('battery', 8))
	end
	assert(not Al.check('battery', 80))
end

os.exit( luaunit.LuaUnit.run() )
