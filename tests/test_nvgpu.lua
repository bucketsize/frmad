#!/usr/bin/env lua
package.path = '?.lua;' .. package.path
require "luarocks.loader"
luaunit = require('luaunit')

local T = require("minilib.timer")
local f = require("fragments.nvgpu")

MTAB = {}

function start_timer(co)
	local t = T.new_timer()
	local inst = coroutine.create(co.co)
	print("start_timer", co.name, "?", inst)
	t:tick(co.ri, function()
		local ok, res = coroutine.resume(inst)
		if not ok then
			print('>> co', co.name, res)
		end
	end)
	t:start(10)
end

function test_01()
	start_timer(f)
end

os.exit( luaunit.LuaUnit.run() )
