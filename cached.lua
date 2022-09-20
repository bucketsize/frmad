#!/usr/bin/env lua

require "luarocks.loader"

local Cache = {}

local Handler = {
   put = function(client, so)
	  local k, v = so:match("([%w_:]+)|(.*)")
	  Cache[k] = v
	  client:send("ok\n")
   end,
   get = function(client, so)
	  local k, v = so:match("([%w_:]+)")
	  if Cache[k] == nil then
		 client:send("\n")
	  else
		 client:send(Cache[k].."\n")
	  end
   end,
   getAll = function(client, so)
	  for k,v in pairs(Cache) do
		 client:send(string.format("%s|%s\n", k, v))
	  end
   end,
}

-----------------------------
local host, port = "*", 51515
if not (arg[1] == "-") then
   host = arg[1]
end
if not (arg[2] == "-") then
   port = tonumber(arg[2])
end
-----------------------------

local CmdServer = require('minilib.cmd_server')
CmdServer:start(host, port, Handler)
