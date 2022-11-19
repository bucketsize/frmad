require "luarocks.loader"

local Util = require('minilib.util')
local Sh = require('minilib.shell')
local alert = require('frmad.config.alerts')

local hwmons={}

-- intel i5 / amd ryzen 2200 g
for i = 0,8 do
	local hwmfd = string.format("/sys/class/hwmon/hwmon%d/name", i)
	if Sh.path_exists(hwmfd) then
		if Util:head_file(hwmfd) == "coretemp" then
			for j = 0,8 do
				local tempfd = string.format("/sys/class/hwmon/hwmon%d/temp%d_label", i, j)
				if Sh.path_exists(tempfd) then
					local templb = Util:head_file(tempfd)
					hwmons[templb] = string.format("/sys/class/hwmon/hwmon%d/temp%d_input", i, j)
				end
			end
			break
		end
	end
end

-- pi 4
hwmons["thermal_zone0"] = "/sys/class/thermal/thermal_zone0/temp"

function cputemp()
	local ts = {}
	for i,v in pairs(hwmons) do
		local h = io.open(v, "r")
		if h then
			local result = h:read("*l")
			ts[i] = tonumber(result)
			h:close()
		end
	end
	return ts
end

function tempdef(cputs)
	-- ryzen 2 2200g
	if cputs["Tdie"] then
		return cputs['Tdie'] / 1000
	end

	-- intel
	if cputs["Core 0"] then
		return cputs['Core 0'] / 1000
	end

	-- pi 4
	if cputs["thermal_zone0"] then
		return cputs['thermal_zone0'] / 1000
	end
end

function co_cputemp()
	while true do
		local cputs = cputemp()
		for i,v in pairs(cputs) do
			MTAB[i] = v / 1000
			alert.check('cpu_temp', MTAB[i])
		end
		MTAB['cpu_temp'] = tempdef(cputs)
		coroutine.yield()
	end
end
return {fn=cputemp, co=co_cputemp, ri=2}
