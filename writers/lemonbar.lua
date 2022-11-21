#!/usr/bin/env lua
require "luarocks.loader"

local util = require("minilib.util")
local fmt = require("frmad.config.formats")
local sym = require("frmad.lib.sym").ascii

function status_line()
    local otab = MTAB 
    local mtab = {}
    for k, v in pairs(otab) do
		if not v then v = "" end
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
			return {sym = sym["net"], val = mtab["net_device"]}
		end
	end)() 
    local gpu = (function() 
		if mtab['gpu_id']=="nv" then
    		return {name="Nv",temp=mtab["nv:gpu_temp"],speed=mtab["nv:gpu_sclk"]}
		end
		if mtab['gpu_id']=="Amd" then
    		return {name="amd",temp=mtab["amd:gpu_temp"],speed=mtab["amd:gpu_sclk"]}
		end
		return {}
	end)() 
    return {
		"%{l}"
		, sym["clock"], os.date("%a %b %d, %Y | %H:%M:%S")
		, "%{c}"
		, "..."
		, "%{r}"
		, sym["cpu"] .. mtab['cpu']
		, sym["temperature"] .. mtab['cpu_temp']
		, "|"
		, sym["gpu"], gpu.name
		, sym["temperature"], gpu.temp
		, "|"
		, sym["mem"] .. mtab['mem']
		, "|"
		, audio.sym, audio.val
		, "|"
		, net.sym, net.val 
		, "|"
		, bat.sym, bat.val
		}
end

function logger()
	while true do
		local hout = io.open("/tmp/frmad.lemonbar.out", "w")
		for _, e in ipairs(status_line()) do
			hout:write(e)
			hout:write(" ")
		end
		hout:write("\n")
		hout:flush()
		hout:close()
		coroutine.yield()
	end
end

return {co=logger, formatter=status_line, ri=2}
