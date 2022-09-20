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
end, {"mcache",	"mlogger"})

-----------------------------------------------------------------
function start()
	local t = Util:new_timer()
    for i, co in pairs(Co) do
        local inst = coroutine.create(co.co)
        print('co/', co.name, co.ri)
		t:tick(co.ri, function()
            Util:run_co(co.name, inst)
        end
        )
    end
    t:start(10)
end
start() -- should block
print("daemon exited ... ")
