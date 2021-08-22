require "luarocks.loader"

local client = require("frmad.cachec")
local util = require("minilib.util")

function test_fragments()
   for k,v in ipairs({"amdgpu","battery","cpu","cpu_freq","cpu_temp","disk","mem","net","process","pulseaudio", "weather"}) do
	  local f = require("frmad." .. v)
	  print(v .. ": ", f.fn())
   end
end

function test_cachec_perf()
   print(os.date())
   for i=1,10000,1 do
	  local k, v = 'keyNN'..tostring(i), "hello !wow." .. tostring(i)
	  client:put(k, v, "string")
	  local r = client:get(k)
	  assert(r == v, "value missmatch " ..v)
   end
   print(os.date())
end

function test_cachec()
   for i=1,5,1 do
	  local k, v = 'key1'..tostring(i), i
	  local s, st = client:put(k, v, "integer")
	  print("put", k, v, s, st)
	  --assert(v == client:get(k))
   end
   for i=1,5,1 do
	  local k, v = 'key2'..tostring(i), 'wow! ..' .. i
	  local s, st = client:put(k, v, "string")
	  print("put", k, v, s, st)
	  assert(v == client:get(k))
   end
   local all = client:getAll()
end
function test_cachec_co()
   function cachec_co()
	  for i = 1,10000,1 do
		 local k, v = 'ko2'..tostring(i), 'wow! ..' .. i
		 local s, st = client:put(k, v, type(v))
		 print("put", k, v, s, st)
		 assert(v == client:get(k))
		 coroutine.yield()
	  end
   end

   local inst = coroutine.create(cachec_co)
   for i = 1,10,1 do
	  util:run_co("cachec_co", inst)
   end
end


test_fragments()
test_cachec_perf()
test_cachec()
test_cachec_co()
