#!/usr/bin/env lua
require "luarocks.loader"

local socket = require("socket")
local util = require("minilib.util")
local formats = require("frmad.formats")
local cachec = require("frmad.cachec")

function status_line()
    local otab = cachec:getAll()
    local mtab = {}
    for k,v in pairs(otab) do
        if formats[k] then
            mtab[k]=string.format(formats[k], v)
        else
            mtab[k]=tostring(v)
        end
    end
    local power = util:if_else(mtab['battery_status'] == "AC"
    , {icon = ">P~", val = "AC"}
    , {icon = ">B~", val = mtab["battery"]})
    local audio = util:if_else(otab['vol'] == nil or otab['vol'] < 1
    , {icon = ">Vx", val = ""}
    , {icon = ">Vo", val = mtab["vol"]})
    return string.format("%%{l} %s %s %s %%{c} >T %s %%{r} >C%s (%s) >M%s >T%s >N%s %s%s %s%s \n"
    , mtab['weather_temperature'], mtab['weather_humidity']
    , mtab['weather_summary']
    , os.date("%a %b %d, %Y | %H:%M:%S")
    , mtab['cpu']
    , mtab['cpu_mfreq']
    , mtab['mem']
    , mtab['cpu_temp']
    , util:if_else(mtab['net_gateway']=="?", "-/-", ".:|")
    , audio.icon, audio.val
    , power.icon, power.val)
end

while true do
    io.write(status_line())
    io.flush()
    socket.sleep(1)
end
