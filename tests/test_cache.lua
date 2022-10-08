#!/usr/bin/env lua

package.path = os.getenv("HOME") .. '/?.lua;'
    .. package.path

-- require "luarocks.loader"

local client = require("frmad.lib.cachec")
local util = require("minilib.util")

function test_cachec_perf()
   print(os.date())
   for i=1,10000,1 do
	  local k, v = 'keyN:N'..tostring(i), "hello !wow." .. tostring(i)
	  client:put(k, v, "string")
	  local r = client:get(k)
	  assert(r == v, "value missmatch " ..v)
   end
   print(os.date())
end

function test_cachec()
   for i=1,5,1 do
	  local k, v = 'key:1'..tostring(i), i
	  local s, st = client:put(k, v, "integer")
	  print("put", k, v, s, st)
	  --assert(v == client:get(k))
   end
   for i=1,5,1 do
	  local k, v = 'key:2'..tostring(i), 'wow! ..' .. i
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
function test_cachec()
   for i=1,5,1 do
	  local k, v = 'key:1'..tostring(i), i
	  local s, st = client:put(k, v, "integer")
	  print("put", k, v, s, st)
	  --assert(v == client:get(k))
   end
   for i=1,5,1 do
	  local k, v = 'key:2'..tostring(i), 'wow! ..' .. i
	  local s, st = client:put(k, v, "string")
	  print("put", k, v, s, st)
	  assert(v == client:get(k))
   end
   local all = client:getAll()
end

function test_cachec_perf()
   print(os.date())
   for i=1,10000,1 do
	  local k, v = 'keyN:N'..tostring(i), "hello !wow." .. tostring(i)
	  client:put(k, v, "string")
	  local r = client:get(k)
	  assert(r == v, "value missmatch " ..v)
   end
   print(os.date())
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


test_cachec()
-- test_cachec_perf()
-- test_cachec_co()
