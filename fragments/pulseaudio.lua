require "luarocks.loader"

local Proc = require('minilib.process')
local Shell = require('minilib.shell')
local Util = require('minilib.util')

function vol_usage()
    local s,v,st={},{},{}
    Proc.pipe()
	.add(Shell.exec('pactl list sinks 2>&1'))
	.add(Proc.branch()
        .add(Shell.grep('Sink #(%w+)'))
        .add(Shell.grep('State: (%w+)'))
        .add(Shell.grep('Volume: f.*'))
		.build())
	.add(Proc.cull())
	.add(Proc.map(function(x)
        if x[1] then table.insert(s,  x[1][1]) end
        if x[2] then table.insert(st, x[2][1]) end
        if x[3] then 
            local vol=0
            -- print("--> vol: ", x[3][1])
            for iv in string.gmatch(x[3][1], "/%s+(%d+)") do
                vol=vol+iv
            end
            vol=vol/2
            table.insert(v, vol) 
        end
		return x
	end))
    -- .add(Shell.echo())
	.run()
	return s, v, st
end
function co_vol_usage()
	while true do
		local s, v, st = vol_usage()
        for i,sink in ipairs(s) do
            MTAB[sink..'.vol'] = v[i]
            MTAB[sink..'.vol_level'] = v[i]*0.05
            MTAB[sink..'.snd_live'] = st[i]
            if st[i] == "RUNNING" then
                MTAB['vol'] = v[i]
                MTAB['vol_level'] = v[i]*0.05
                MTAB['snd_live'] = st[i]
                MTAB['pa_sink'] = sink

            end
        end
		coroutine.yield()
	end
end
return {fn=vol_usage, co=co_vol_usage, ri=2}
