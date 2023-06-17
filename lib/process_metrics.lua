local fmt = require("frmad.config.formats")
local sym = require("frmad.lib.sym").ascii

local mtab = function(k)
	if not MTAB[k] then
		return " ?"
	end
	return fmt:formatvalue(k, MTAB[k])
end

return function()
	return {
		bat = (function()
			if MTAB["battery_status"] == "Full" then
				return { sym = sym["battery_charging"], val = mtab("battery") }
			end
			if MTAB["battery_status"] == "Charging" then
				return { sym = sym["battery_charging"], val = mtab("battery") }
			end
			if MTAB["battery_status"] == "Discharging" then
				return { sym = sym["battery_discharging"], val = mtab("battery") }
			end
			return { sym = sym["AC"], val = "" }
		end)(),
		audio = (function()
			if MTAB["vol"] == nil or mtab("vol") < 1 then
				return { sym = sym["snd_mute"], val = "" }
			else
				return { sym = sym["snd"], val = mtab("vol") }
			end
		end)(),
		net = (function()
			if MTAB["net_gateway"] == "?" then
				return { sym = sym["net_disabled"], val = "" }
			else
				if MTAB["net_device"]:match("^wl") then
					return { sym = sym["wln"], val = mtab("net_gateway") }
				end
				if MTAB["net_device"]:match("^en") then
					return { sym = sym["eth"], val = mtab("net_gateway") }
				end
				return { sym = sym["net"], val = mtab("net_gateway") }
			end
		end)(),
		mem = (function()
			return { sym = sym["mem"], val = mtab("mem") }
		end)(),
		cpu = (function()
			return { sym = sym["cpu"], val = mtab("cpu") }
		end)(),
		cpu_temp = (function()
			return { sym = sym["temperature"], val = mtab("cpu_temp") }
		end)(),
		gpu = (function()
			local gpu_id = MTAB["gpu_id"]
			if gpu_id == nil then
				gpu_id = "Gpu"
			end
			return {
				sym = sym["gpu_" .. gpu_id],
				temp = mtab(gpu_id .. ":gpu_temp"),
				speed = mtab(gpu_id .. ":gpu_sclk"),
			}
		end)(),
	}
end
