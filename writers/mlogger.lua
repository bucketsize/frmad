require "luarocks.loader"

local Fmt = require('frmad.config.formats')

-- Log to '/var/tmp/sys_mon.out' --
function logger()
    while true do
        local hout = io.open("/tmp/sys_mon.out", "w")
        for k, v in pairs(MTAB) do
            hout:write(k,': ', Fmt:formatvalue(Fmt, k, v), "\n")
        end
        hout:close()
        coroutine.yield()
    end
end
return {co=logger, ri=2}
