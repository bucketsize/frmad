require "luarocks.loader"

local Util = require('minilib.util')

function gpu_usage()
	local vram_used = tonumber(Util:read("/sys/class/drm/card0/device/mem_info_vram_used"))
	local vram = tonumber(Util:read("/sys/class/drm/card0/device/mem_info_vram_total"))
	local tgpu=0
	local clkm=0
	local clks=0
	local result = Util:read("/sys/kernel/debug/dri/0/amdgpu_pm_info")
	if not (result == nil) then
		local tgpu = string.match(result, "GPU Temperature: (%d+) C")
		local clkm = string.match(result, "%s+(%d+) MHz%s+%ZMCLK")
		local clks = string.match(result, "%s+(%d+) MHz%s+%ZSCLK")
	end
	return vram, vram_used, tonumber(tgpu),tonumber(clkm),tonumber(clks)
end
function co_gpu_usage()
	while true do
		local vram,vram_used,tgpu,gmf,gsf=gpu_usage()
		-- print('->', vram,vram_used,tgpu,gmf,gsf)
        if vram then
            MTAB['gpu_id'] = "amd"
            MTAB['amd:gpu_mem'] = vram / 1000000
            MTAB['amd:gpu_mem_used'] = vram_used / 1000000
            MTAB['amd:gpu_mem_used_pc'] = vram_used * 100 / vram
            MTAB['amd:gpu_temp'] = tgpu
            MTAB['amd:gpu_temp'] = tgpu
            MTAB['amd:gpu_mclk'] = gmf
            MTAB['amd:gpu_sclk'] = gsf
        end
		coroutine.yield()
	end
end
return {fn=gpu_usage, co=co_gpu_usage, ri=2}
