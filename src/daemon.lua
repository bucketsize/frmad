#!/usr/bin/env lua
require "luarocks.loader"

local Util = require('minilib.util')
local Fmt = require('frmad.formats')

EPOC=1
MTAB={}
for i,k in Fmt:ipairs() do
   MTAB[k] = 0
end

local Co = Util:map(function(s)
	local codef = require('frmad.' .. s)
	codef.name = s
	return codef
end, {"cpu", "mem", "cpu_temp", "amdgpu", "battery", "net", "pulseaudio", "weather"})

Util:map(function(s)
	local codef = require('frmad.' .. s)
	codef.name = s
	table.insert(Co, codef)
end, {"mcache",	"mlogger"})

-----------------------------------------------------------------
function start()
   for i, co in pairs(Co) do
      local inst = coroutine.create(co.co)
      print('co/', co.name, co.ri)
	  Util.Timer:tick(co.ri,
					  function()
						 Util:run_co(co.name, inst)
					  end
	  )
   end
   Util.Timer:start()
end
start()
