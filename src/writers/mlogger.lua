require "luarocks.loader"

local Fmt = require('frmad.formats')

-- Log to '/var/tmp/sys_mon.out' --
function logger()
    while true do
        local hout = io.open("/tmp/sys_mon.out", "w")
        for k, v in pairs(MTAB) do
            local f = Fmt[k]
            if not f then
                k = k:match("[%w_]+:([%w_]+)")
                f = Fmt[k]
            end
            --print("-> ", k, v, type(v))
            if not k then k = "__unknown" end    
            if not v then v = "__unv_"..k end    
            if not f then f = "__unf_"..k end    
            hout:write(k,': ',string.format(f, v), "\n")
        end
        hout:close()
        coroutine.yield()
    end
end
return {co=logger, ri=2}
