#!/usr/bin/env lua
require "luarocks.loader"

local util = require("minilib.util")

local Client = {}
function Client.configure(self, client)
   self.client = client
end
function Client.put(self, k, v, type)
    if not k then k = "__unknown" end    
    if not v then v = "__unk_"..k end    
   local s, status, partial = self.client:send("put", string.format("%s|%s::%s\n", k, tostring(v), type))
   return s, status
end
function Client.get(self, k)
	local s, status, partial = self.client:send("get", string.format("%s\n", k))
	local v,t = s:match("([%w%p%s]+)::(%w+)")
	return v
end
function Client.getAll(self)
	local rx = self.client:sendxr("getAll", "BLAH\n")
	local mtab = util:fold(
	   function(s, a)
		  local k, v, ty = s:match("([%w_]+)|([%w%p%s]+)::(.*)")
		  local r
		  if k == nil then
			 k = 'nothing'
		  end
		  if ty == "number" then
			 r=tonumber(v)
		  else
			 if ty == "integer" then
				r=math.floor(tonumber(v))
			 else
				r=v
			 end
		  end
		  a[k]=r
		  return a
	   end, rx, {})
	return mtab
end
-----------------------------
local host, port = "localhost", 51515
if arg[1] and not (arg[1] == "-") then
   host = arg[1]
end
if arg[1] and not (arg[2] == "-") then
   port = tonumber(arg[2])
end
-----------------------------

local CmdClient = require('minilib.cmd_client')
CmdClient:configure(host, port)
Client:configure(CmdClient)

return Client
