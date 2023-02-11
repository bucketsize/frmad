#!/usr/bin/env lua
require "luarocks.loader"

local fmt = require("frmad.config.formats")
local sym = require("frmad.lib.sym").ascii

local function status_line()
    local mtab = function(k)
		if not MTAB[k] then return " ?" end
        return fmt:formatvalue(k, MTAB[k])
    end
	local bat = (function()
		if MTAB['battery_status'] == "Full" then
			return {sym = sym["battery_charging"], val = mtab("battery")}
		end
		if MTAB['battery_status'] == "Charging" then
			return {sym = sym["battery_charging"], val = mtab("battery")}
		end
		if MTAB['battery_status'] == "Discharging" then
			return {sym = sym["battery_discharging"], val = mtab("battery")}
		end
		return {sym = sym["AC"], val = ""}
	end)()
    local audio = (function()
		if MTAB['vol'] == nil or mtab('vol') < 1 then
			return {sym = sym["snd_mute"], val = ""}
		else
			return {sym = sym["snd"], val = mtab("vol")}
		end
	end)()
    local net = (function()
		if MTAB['net_gateway']=="?" then
    		return {sym = sym["net_disabled"], val = ""}
    	else
			if MTAB["net_device"]:match("^wl") then
				return {sym = sym["wln"], val = mtab("net_gateway")}
			end
			if MTAB["net_device"]:match("^en") then
				return {sym = sym["eth"], val = mtab("net_gateway")}
			end
			return {sym = sym["net"], val = mtab("net_gateway")}
		end
	end)()
	local gpu = (function()
		local gpu_id = MTAB['gpu_id']
    	return {sym=sym["gpu_"..gpu_id],temp=mtab(gpu_id..":gpu_temp"),speed=mtab(gpu_id..":gpu_sclk")}
	end)()
    return string.format(
		"%%{l} %s%s %%{c}...%%{r} %s%s %s%s | %s %s%s | %s%s | %s%s | %s%s | %s%s\n"
		, sym["clock"], os.date("%a %b %d, %Y | %H:%M:%S")
		, sym["cpu"], mtab('cpu')
		, sym["temperature"], mtab('cpu_temp')
		, gpu.sym, sym["temperature"], gpu.temp
		, sym["mem"], mtab('mem')
		, audio.sym, audio.val
		, net.sym, net.val
		, bat.sym, bat.val
		)
end

return {co=function ()
	while true do
		local hout = assert(io.open("/tmp/frmad.lemonbar.out", "w"))
		hout:write(status_line())
		hout:close()
		coroutine.yield()
	end
end
, formatter=status_line, ri=2}
