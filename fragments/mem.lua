require "luarocks.loader"

local alert = require('frmad.config.alerts')
local Proc = require('minilib.process')
local Shell = require('minilib.shell')

function mem_usage()
	local rf,rt,sf,st
	Proc.pipe()
	.add(Shell.cat("/proc/meminfo"))
	.add(Proc.branch()
		.add(Shell.grep("MemTotal:%s+(%d+) kB"))
		.add(Shell.grep("MemFree:%s+(%d+) kB"))
		.add(Shell.grep("SwapTotal:%s+(%d+) kB"))
		.add(Shell.grep("SwapFree:%s+(%d+) kB"))
		.build())
	.add(Proc.cull())
	.add(Proc.map(function(x)
		if x == nil then return x end
		if not (x[1]==nil) then rt=x[1][1] end
		if not (x[2]==nil) then rf=x[2][1] end
		if not (x[3]==nil) then st=x[3][1] end
		if not (x[4]==nil) then sf=x[4][1] end
		return x
	end))
	-- .add(Shell.echo())
	.run()

	return 1-rf/rt, 1-sf/st
end
function co_mem_usage()
	while true do
		local m=mem_usage()
		MTAB['mem'] = m*100
		MTAB['mem_level'] = m*5
		coroutine.yield()
	end
end
return {fn=mem_usage, co=co_mem_usage, ri=2}
