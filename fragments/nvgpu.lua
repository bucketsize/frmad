require "luarocks.loader"

local Ut = require('minilib.util')
local Sh = require('minilib.shell')

function nv_gpu_usage(l)
	local _,pwr,tgpu,clkm,clks = l:match("(%d+)%s+(%d+)%s+(%d+)%s+-%s+(%d+)%s+(%d+)")
	local vram_used = 0
	local vram = 0 
	return vram, vram_used, tonumber(tgpu),tonumber(clkm),tonumber(clks)
end
function co_gpu_usage()
	local h = assert(io.popen("nvidia-smi dmon -d 2 -s pc"))
	while true do
		local l = h:read("*l")
		local vram,vram_used,tgpu,gmf,gsf=nv_gpu_usage(l)
		-- print('co_gpu_usage', vram,vram_used,tgpu,gmf,gsf)
        if vram then
            MTAB['gpu_id'] = "nv"
			MTAB['nv:gpu_mem'] = vram / 1000000
            MTAB['nv:gpu_mem_used'] = vram_used / 1000000
            MTAB['nv:gpu_mem_used_pc'] = vram_used * 100 / vram
            MTAB['nv:gpu_temp'] = tgpu
            MTAB['nv:gpu_temp'] = tgpu
            MTAB['nv:gpu_mclk'] = gmf
            MTAB['nv:gpu_sclk'] = gsf
        end
		coroutine.yield()
	end
	--h:close()
end
return {fn=function()end, co=co_gpu_usage, ri=2}
