#!/usr/bin/env lua
require "luarocks.loader"

local util = require("minilib.util")
local fmt = require("frmad.config.formats")
local sym = require("frmad.lib.sym").ascii

local function status_line()
    local otab = MTAB 
    local mtab = {}
    for k, v in pairs(otab) do
        mtab[k] = fmt:formatvalue(k, v)
    end
	local bat = (function()
		if mtab['battery_status'] == "Full" then
			return {sym = sym["battery_charging"], val = mtab["battery"]}
		end
		if mtab['battery_status'] == "Charging" then
			return {sym = sym["battery_charging"], val = mtab["battery"]}
		end
		if mtab['battery_status'] == "Discharging" then
			return {sym = sym["battery_discharging"], val = mtab["battery"]}
		end
		return {sym = sym["AC"], val = ""}
	end)()
    local audio = (function() 
		if otab['vol'] == nil or otab['vol'] < 1 then
			return {sym = sym["snd_mute"], val = ""}
		else
			return {sym = sym["snd"], val = mtab["vol"]}
		end
	end)()
    local net = (function() 
		if mtab['net_gateway']=="?" then
    		return {sym = sym["net_disabled"], val = ""}
    	else 
			return {sym = sym["net"], val = ""}
		end
	end)() 
	return string.format([[[
			{"full_text": "%sC %sH %s"},
			{"full_text": "| %s%s"},
			{"full_text": "| %s %s"},
			{"full_text": "%s %s"},
			{"full_text": "%s %s | %s %s"},
			{"full_text": "| %s %s %s"},
			{"full_text": "| %s %s"},
			{"full_text": "| %s %s"},
			{"full_text": "| %s %s"}],]]
			, mtab['weather_temperature'], mtab['weather_humidity'], mtab['weather_summary']
			, sym['eth'], util:if_else(mtab['net_gateway']=="?", sym['disabled'], "")
			, sym['cpu'], mtab['cpu']
			, sym['temperature'], mtab['cpu_temp']
			, sym['mem'], mtab['mem'], sym['gpu'], mtab['gpu_mem_used_pc']
			, sym['disc'], mtab['discio'], mtab['fs_free']
			, audio.icon, audio.val
			, bat.icon, bat.val
			, sym['clock'], os.date("%a %b %d, %Y | %H:%M"))
end

return {co=function ()
	local hout = assert(io.open("/tmp/frmad.i3bar.out", "w"))
	hout:write('{"version":1}')
	hout:write('[')
	hout:write('[],')
	hout:close()
	while true do
		hout = assert(io.open("/tmp/frmad.i3bar.out", "w"))
		hout:write(status_line())
		hout:close()
		coroutine.yield()
	end
end
, ri=2}
