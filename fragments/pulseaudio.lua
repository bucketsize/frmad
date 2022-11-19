require "luarocks.loader"

local Proc = require('minilib.process')
local Shell = require('minilib.shell')
local Util = require('minilib.util')
local M = require("minilib.monad")

function vol_usage_m()
    local s,v,st,na={},{},{},{}
	M.IO.read_lines_pout("pactl list sinks 2>&1")
		:fmap(function(ls)
			ls:fmap(function(l)
				local n = l:match('Name: (.+)')
				if n then table.insert(na, n) end
				local i = l:match('Sink #(%w+)')
				if i then table.insert(s, i) end
				local j = l:match('State: (%w+)')
				if j then table.insert(st, j) end
				local k = l:match('Volume: f.*')
				if k then 
					local vol=0
					-- print("vol_usage", k)
					for iv in string.gmatch(k, "/%s+(%d+)") do
						vol=vol+iv
					end
					vol=vol/2
					table.insert(v, vol) 
				end
			end)
		end)
	return {names = na, sinks = s, vols = v, states = st}
end
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
		if x == nil then return x end
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
	.run()
	return {sinks = s, vols = v, states = st}
end
function co_vol_usage()
	while true do
		local s, v, st = vol_usage_m()
        for i,sink in ipairs(s) do
            MTAB[sink..':vol'] = v[i]
            MTAB[sink..':vol_level'] = v[i]*0.05
            MTAB[sink..':snd_live'] = st[i]
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
return {fn=vol_usage_m, co=co_vol_usage, ri=2}
