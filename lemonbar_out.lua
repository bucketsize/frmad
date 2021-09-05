#!/usr/bin/env lua
require "luarocks.loader"

local socket = require("socket")
local util = require("minilib.util")
local fmt = require("frmad.config.formats")
local cachec = require("frmad.lib.cachec")
local sym = require("frmad.lib.sym").ascii

function status_line()
    local otab = cachec:getAll()
    local mtab = {}
    for k, v in pairs(otab) do
        mtab[k] = fmt:formatvalue(fmt, k, v)
    end
    local power = util:if_else(mtab['battery_status'] == "AC"
    , {sym = sym["AC"], val = ""}
    , {sym = sym["battery"], val = mtab["battery"]})
    local audio = util:if_else(otab['vol'] == nil or otab['vol'] < 1
    , {sym = sym["snd_mute"], val = ""}
    , {sym = sym["snd"], val = mtab["vol"]})
    local net = util:if_else(mtab['net_gateway']=="?"
    , {sym = sym["net_disabled"], val = ""}
    , {sym = sym["net"], val = ""}) 
    return string.format("%%{l} %s %s %s %%{c} %s%s %%{r}%s%s (%s) %s%s %s%s %s%s %s%s %s%s \n"
    , mtab['weather_summary'], mtab['weather_temperature'], mtab['weather_humidity']
    , sym["clock"], os.date("%a | %b %d, %Y | %H:%M:%S")
    , sym["cpu"], mtab['cpu'], mtab['m:cpu_freq']
    , sym["mem"], mtab['mem']
    , sym["temperature"], mtab['cpu_temp']
    , net.sym, net.val 
    , audio.sym, audio.val
    , power.sym, power.val)
end

while true do
    io.write(status_line())
    io.flush()
    socket.sleep(1)
end
