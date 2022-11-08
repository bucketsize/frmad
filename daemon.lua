#!/usr/bin/env lua
require "luarocks.loader"

local Util = require('minilib.util')
local Fmt = require('frmad.config.formats')
local M = require("minilib.monad")

EPOC=2
MTAB={}

local Cof = M.List.of({"cpu","cpu_freq", "mem", "cpu_temp", "amdgpu", "battery", "net", "pulseaudio", "weather"})
	:fmap(function(s)
		local codef = require('frmad.fragments.' .. s)
		codef.name = s
		return codef
	end)
local Cow = M.List.of({"mlogger", "clogger", "lemonbar"})
	:fmap(function(s)
		local codef = require('frmad.writers.' .. s)
		codef.name = s
		return codef
	end)

-----------------------------------------------------------------
function start_timer()
	local t = Util.new_timer()
	local sched_co_exec = function (co)
		local inst = coroutine.create(co.co)
		print("start_timer", co.name, "?", inst)
		t:tick(co.ri, function()
			local ok, res = coroutine.resume(inst)
			if not ok then
				print('>> co', co.name, res)
			end
		end)
	end
	Cof:fmap(sched_co_exec)
	Cow:fmap(sched_co_exec)

	local tcpif = require("frmad.interfaces.tcp")
	tcpif.name = "tcpif"
	sched_co_exec(tcpif)
    
	t:start()
end
start_timer() -- should block
print("daemon exited ... ")
