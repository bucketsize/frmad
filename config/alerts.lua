#!/usr/bin/env lua
require "luarocks.loader"

local Util = require("minilib.util")

local Al = {
	cpu = {
		compare = ">",
		trigger = 59,
		count = 0,
		highmark = 10
	},
	mem = {
		compare = ">",
		trigger = 79,
		count = 0,
		highmark = 10
	},
	cpu_temp = {
		compare = ">",
		trigger = 79,
		count = 0,
		highmark = 5
	},
	battery = {
		compare = "<",
		trigger = 10,
		count = 0,
		highmark = 5
	}
}

function Al.compare(p, a)
	local ad = Al[p]
	local c, b = ad.compare, ad.trigger
	if 	(c == ">"  and a >  b) or 
		(c == ">=" and a >= b) or
		(c == "<"  and a <  b) or
		(c == "<=" and a <= b) or
		(c == "==" and a == b) or
		(c == "!=" and a ~= b) then
		return true
	else
		return false
	end
end

Al.compare_str = {
	[">" ] = "is running high!",
	[">="] = "is running somewhat high!",
	["<" ] = "is running low!",
	["<="] = "is running somewhat low",
	["=="] = "is",
	["!="] = "is not as expected!",
}

function Al.alert(p, pc)
	local al = Al[p]
	print("Al.alert: ", p, pc, Al.compare_str[al.compare])
	Util:exec(string.format('notify-send -u critical -c system "%s %s (%s)"'
		, p
		, Al.compare_str[al.compare]
		, pc))
end

function Al.check(p, pc)
	-- print("Al.check:", p, pc)
	if Al.compare(p, pc) then
		-- print("Al.check, trigger:", p, pc)
		if Al[p].count > Al[p].highmark then
			Al.alert(p, pc)
			Al[p].highmark = Al[p].highmark * 2 -- exponential backoff
		end
		Al[p].count = Al[p].count + 1
		return true
	else
		Al[p].count = 0
		return false
	end
end

return Al
