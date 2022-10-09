#!/usr/bin/env lua
require "luarocks.loader"

local Util = require('minilib.util')
local Fmt = require('frmad.config.formats')

EPOC=2
MTAB={}

local Co = Util:map(function(s)
	local codef = require('frmad.fragments.' .. s)
	codef.name = s
	return codef
end, {"cpu","cpu_freq", "mem", "cpu_temp", "amdgpu", "battery", "net", "pulseaudio", "weather"})

Util:map(function(s)
	local codef = require('frmad.writers.' .. s)
	codef.name = s
	table.insert(Co, codef)
end, {"mlogger", "clogger", "lemonbar", "i3bar"})

-----------------------------------------------------------------
function start()
	local t = Util.new_timer()
    for i, co in pairs(Co) do
        local inst = coroutine.create(co.co)
        print('>> co', co.name, "?", inst)
		t:tick(co.ri, function()
			-- print(">> co resume", co.name, co.ri,  inst)
			local ok, res = coroutine.resume(inst)
			if not ok then
				print('>> co', co.name, res)
			end
		end
        )
    end
    t:start()
end
start() -- should block
print("daemon exited ... ")
