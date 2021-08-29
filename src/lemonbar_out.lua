#!/usr/bin/env lua
require "luarocks.loader"

local socket = require("socket")
local util = require("minilib.util")
local formats = require("frmad.formats")
local cachec = require("frmad.cachec")

local Sym ={
	cpu = "Cpu",
	gpu = "Gpu",
	mem = "Mem",
	eth = "Eth",
	wifi = "Wlan",
	disc = "Df",
	clock = "Tz",
	battery = "Bat ",
	AC = "Pow ",
	snd = "Snd",
	snd_mute = "Snd",
	disabled = "X",
	temperature = "T ",
	-- cpu = "",
	-- gpu = "g",
	-- mem = "",
	-- eth = "",
	-- wifi = "",
	-- disc = "",
	-- clock = "",
	-- battery = "",
	-- AC = "",
	-- snd = "",
	-- snd_mute = "",
	-- disabled = "",
	-- temperature = "",
}

function co_out()
	while true do
		local otab = cachec:getAll()
		local mtab = {}
		for k,v in pairs(otab) do
			if not (formats[k] == nil) then
				mtab[k]=string.format(formats[k], v)
			end
		end

		local power = util:if_else(mtab['battery_status'] == "AC"
			, {icon = Sym["AC"], val = "AC"}
			, {icon = Sym["battery"], val = mtab["battery"]})
		local audio = util:if_else(otab['vol'] == nil or otab['vol'] < 1
			, {icon = Sym["snd_mute"], val = ""}
			, {icon = Sym["snd"], val = mtab["vol"]})
		print(string.format("%%{l} %s %s %s %%{c} %s %s %%{r} %s%s  %s%s  %s%s  %s%s  %s%s  %s%s "
				, mtab['weather_temperature'], mtab['weather_humidity'], mtab['weather_summary']
				, Sym['clock'], os.date("%a %b %d, %Y | %H:%M")
				, Sym['cpu']  , mtab['cpu']
				, Sym['mem']  , mtab['mem']
				, Sym['temperature'], mtab['cpu_temp']
				, Sym['eth']  , util:if_else(mtab['net_gateway']=="?", Sym['disabled'], "")
				, audio.icon  , audio.val
				, power.icon  , power.val))
		coroutine.yield()
	end
end

local co = coroutine.create(co_out)
while true do
	util:run_co('lemonbar_out', co)
	socket.sleep(2)
end
