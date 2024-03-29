require "luarocks.loader"

local Util = require('minilib.util')

function bat_usage()
	local cap = Util:head_file("/sys/class/power_supply/BAT0/capacity")
	if cap == nil or cap == "" then
		cap = "0"
	end

	local status = Util:head_file("/sys/class/power_supply/BAT0/status")
	if status == nil or status == "" then
		status = "AC"
	end

	return tonumber(cap), status
end

function co_bat_usage()
	while true do
		local level,status=bat_usage()
		MTAB['battery_status']=status
		MTAB['battery']=level
		coroutine.yield()
	end
end
return {fn=bat_usage, co=co_bat_usage, ri=2}
