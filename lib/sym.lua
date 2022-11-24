-- https://unicode.org/emoji/charts/full-emoji-list.html
-- https://www.fontspace.com/unicode/analyzer

local up = utf8.char(8593)
local dw = utf8.char(8595)
local no = utf8.char(1509)
local atom = utf8.char(1431)
local th = utf8.char(1002)
return {
    glyps = {
        cpu = atom.."c",
        gpu = atom.."g",
        mem = utf8.char(1234), --book
        eth = utf8.char(1329), --link
        wifi = utf8.char(128246), --antenna
        net = utf8.char(128423), --network
        net_disabled = utf8.char(128423)..no,
        disc = utf8.char(1213),
        clock = utf8.char(962),
        battery = utf8.char(128267),
        battery_charging = utf8.char(128267)..up,
        battery_discharging = utf8.char(128267)..dw,
        AC = utf8.char(128268), --plug
        snd = utf8.char(128266),
        snd_mute = utf8.char(128263),
        temperature = th,
    },
    ascii = {
        cpu = "Cpu",
        gpu = "Gpu",
		gpu_nv = "Nv",
		gpu_amd = "Amd",
        mem = "Mem",
        eth = "Enp ",
        wln = "Wlp ",
        net = "Net ",
        net_disabled = "Net?",
        disc = "Df",
        clock = "T- ",
        battery = "Bat  ",
        battery_charging = "Bat+ ", 
        battery_discharging = "Bat- ",
        AC = "Pow",
        snd = "Snd",
        snd_mute = "Snd?",
        temperature = "Th ",
    }
}
