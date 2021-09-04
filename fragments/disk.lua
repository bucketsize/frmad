local Sh = require('minilib.shell')
local Pr = require('minilib.process')
local Util = require('minilib.util')

discstat_paths = Util:join(" ", {
    "/sys/block/mmc*/stat",
    "/sys/block/sd*/stat",
    "/sys/block/hd*/stat"
})
print("dps:", discstat_paths) 

discstat_files = {}
Pr.pipe()
.add(Sh.exec(string.format('find %s -type f,l', discstat_paths)))
.add(function(f)
    if Util:file_exists(f) then
        table.insert(discstat_files, f)
    end
end)
.run()

print("dfs:", #discstat_files, discstat_files) 
Util:printITable(discstat_files)

function disc_usage()
    local du = {}
    for i,f in ipairs(discstat_files) do 
        local handle = io.open(f, "r")
        if handle then
            local result = handle:read("*l")
            handle:close()
            local label = f:match("/sys/block/(%w+)/stat")
            local v={}
            for d in string.gmatch(result, "%d+") do
                table.insert(v,d)
            end
            table.insert(du, {label, v[1], v[5]}) -- -> {sda, rb, wb}
        end
    end
    return du
end

function co_disc_usage()
    while true do
        local du = disc_usage()
        for i,dui in ipairs(du) do
            local l,r,w = dui
            MTAB[l..':discio_r'] = math.floor(r / 1000)
            MTAB[l..':discio_w'] = math.floor(w / 1000)
            MTAB[l..':discio'] = math.floor((r+w) / 1000)
        end
        coroutine.yield()
    end
end
return {fn=disc_usage, co=co_disc_usage, ri=2}
