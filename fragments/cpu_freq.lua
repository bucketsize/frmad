require "luarocks.loader"

local Util = require('minilib.util')

local cpufreq_files={}
Util:stream_exec("ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq", function(f)
   table.insert(cpufreq_files,f)
end)
function cpu_freq()
   local freq = {}
   for i,v in ipairs(cpufreq_files) do
      local handle = io.open(v, "r")
      if handle then
         local result = handle:read("*l")
         handle:close()
         freq[i] = tonumber(result)/1000 -- -> MHz
      end
   end
   return freq
end
function co_cpu_freq()
   while true do
      local freq=cpu_freq()
      local sfreq,s = 0,0
      for i,v in ipairs(freq) do
         MTAB[tostring(i-1)..':cpu_freq'] = v
         sfreq = sfreq + v
         s = i
      end
      MTAB["m:cpu_freq"] = sfreq/s
      coroutine.yield()
   end
end
return {fn=cpu_freq, co=co_cpu_freq, ri=2}
