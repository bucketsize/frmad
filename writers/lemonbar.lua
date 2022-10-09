#!/usr/bin/env lua
require "luarocks.loader"

local util = require("minilib.util")
local fmt = require("frmad.config.formats")
local sym = require("frmad.lib.sym").ascii

function status_line()
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
    return string.format("%%{l} %s %s %s %%{c} %s%s %%{r}%s%s (%s) %s%s %s%s %s%s %s%s %s%s \n"
		, mtab['weather_summary'], mtab['weather_temperature'], mtab['weather_humidity']
		, sym["clock"], os.date("%a | %b %d, %Y | %H:%M:%S")
		, sym["cpu"], mtab['cpu'], mtab['m:cpu_freq']
		, sym["mem"], mtab['mem']
		, sym["temperature"], mtab['cpu_temp']
		, net.sym, net.val 
		, audio.sym, audio.val
		, bat.sym, bat.val)
end

function logger()
	while true do
		local hout = io.open("/tmp/frmad.lemonbar.out", "w")
		hout:write(status_line())
		hout:close()
		coroutine.yield()
	end
end

return {co=logger, ri=2}
