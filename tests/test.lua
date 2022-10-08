#!/usr/bin/env lua
package.path = '?.lua;' .. package.path
require "luarocks.loader"
luaunit = require('luaunit')

local util = require("minilib.util")

function test_fragments()
   for k,v in ipairs({"amdgpu","battery","cpu","cpu_freq","cpu_temp","disk","mem","net","process","pulseaudio", "weather"}) do
	  local f = require("frmad.fragments." .. v)
      local r = f.fn()
      if type(r) == "table" then
          print(v..":")
          util:printOTable(r)
      else
          print(v .. ": ", r)
      end
   end
end
os.exit( luaunit.LuaUnit.run() )
