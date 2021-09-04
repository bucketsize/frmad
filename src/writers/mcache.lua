require "luarocks.loader"

local Fmt = require('frmad.formats')
local cachec = require("frmad.cachec")

function mcache()
    while true do
        for k, v in pairs(MTAB) do
            if not Fmt[k] then
                k = k:match("[%w_]+:([%w_]+)")
            end
            if not v then v = 0 end
            local s, st = cachec:put(k, v, type(v))
            if not (s == "ok") then
                print("error: mcache", k, v, type(v), s, st)
            end
        end
        coroutine.yield()
    end
end
return {co=mcache, ri=2}
