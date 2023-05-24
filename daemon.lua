#!/usr/bin/env lua
require("luarocks.loader")

local M = require("minilib.monad")
local T = require("minilib.timer")
local L = require("minilib.logger").create()

EPOC = 2
MTAB = {}

local Cof = M.List
	.of({
		"cpu",
		"cpu_freq",
		"cpu_temp",
		"mem",
		"amdgpu",
		"nvgpu",
		"battery",
		"net",
		"pulseaudio",
		"weather",
	})
	:fmap(function(s)
		local codef = require("frmad.fragments." .. s)
		codef.name = s
		return codef
	end)
local Cow = M.List
	.of({
		-- "mlogger",
		"clogger",
		"lemonbar",
		-- "mcache"
	})
	:fmap(function(s)
		local codef = require("frmad.writers." .. s)
		codef.name = s
		return codef
	end)

-----------------------------------------------------------------
local function start_timer()
	local t = T.new_timer()
	local sched_co_exec = function(co)
		local inst = coroutine.create(co.co)
		print("start_timer", co.name, "?", inst)
		t:tick(co.ri, function()
			local status = coroutine.status(inst)
			if status == "dead" then
				L:info("tick, dead co %s", co.name)
				return
			end
			local ok, res = coroutine.resume(inst)
			if not ok then
				L:info("tick, failed to resume %s, %s", co.name, res)
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
