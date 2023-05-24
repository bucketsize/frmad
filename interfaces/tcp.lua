#!/usr/bin/env lua

require("luarocks.loader")

local Cache = MTAB

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
			client:send(Cache[k] .. "\n")
		end
	end,
	getAll = function(client, so)
		for k, v in pairs(Cache) do
			client:send(string.format("%s|%s\n", k, v))
		end
	end,
}

local CmdServer = require("minilib.cmd_server")

return {
	co = function()
		CmdServer:start("localhost", 49075, Handler)
		CmdServer:run_nonblocking({ timeout = 0.1 })
	end,
	ri = 0.1,
}
