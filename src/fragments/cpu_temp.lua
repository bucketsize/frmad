require "luarocks.loader"

local Util = require('minilib.util')
local alert = require('frmad.alerts')

local hwmons={}

-- ryzen 2 2200g
Util:stream_exec("ls /sys/class/hwmon/hwmon*/temp*_label", function(f)
	local d = string.gsub(Util:read(f, 'r'), '%c', '', 1)
	local h = string.gsub(f, 'label', 'input', 1)
	--print('--> cpuT',h)
	hwmons[d] = h
end)

-- pi 4
hwmons["thermal_zone0"] = "/sys/class/thermal/thermal_zone0/temp"

function cputemp()
	local ts = {}
	for i,v in pairs(hwmons) do
		local handle = io.open(v, "r")
		local result = handle:read("*l")
		handle:close()
		ts[i] = tonumber(result)
		--print('--> cpuT',i,result)
	end
	return ts
end

function co_cputemp()
	while true do
		local cputs = cputemp()
		for i,v in pairs(cputs) do
			MTAB[i] = v / 1000
			alert:check('cpu_temp', MTAB[i])
		end

		-- ryzen 2 2200g
		if cputs["Tdie"] then
			MTAB['cpu_temp'] = cputs['Tdie'] / 1000
		end

		-- pi 4
		if cputs["thermal_zone0"] then
			MTAB['cpu_temp'] = cputs['thermal_zone0'] / 1000
		end

		coroutine.yield()
	end
end
return {fn=cputemp, co=co_cputemp, ri=2}
