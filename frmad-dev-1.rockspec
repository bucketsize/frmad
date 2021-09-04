package = "frmad"
version = "dev-1"
source = {
   url = "."
}
description = {
   homepage = "",
   license = "EULA"
}
dependencies = {
   "lua >= 5.1",
   "http",
}
build = {
	type = "none",
	install = {
        lua = {
            ["frmad.config.formats"] = "config/formats.lua",
            ["frmad.config.alerts"] = "config/alerts.lua",

            ["frmad.fragments.amdgpu"] = "fragments/amdgpu.lua",
            ["frmad.fragments.battery"] = "fragments/battery.lua",
            ["frmad.fragments.cpu"] = "fragments/cpu.lua",
            ["frmad.fragments.cpu_freq"] = "fragments/cpu_freq.lua",
            ["frmad.fragments.cpu_temp"] = "fragments/cpu_temp.lua",
            ["frmad.fragments.disk"] = "fragments/disk.lua",
            ["frmad.fragments.mem"] = "fragments/mem.lua",
            ["frmad.fragments.net"] = "fragments/net.lua",
            ["frmad.fragments.process"] = "fragments/process.lua",
            ["frmad.fragments.pulseaudio"] = "fragments/pulseaudio.lua",
            ["frmad.fragments.weather"] = "fragments/weather.lua",

            ["frmad.writers.clogger"] = "writers/clogger.lua",
            ["frmad.writers.mcache"] = "writers/mcache.lua",
            ["frmad.writers.mlogger"] = "writers/mlogger.lua",

            ["frmad.lib.cachec"] = "lib/cachec.lua",
            ["frmad.lib.sym"] = "lib/sym.lua",
        },
        bin = {
            ["frmad.cached"] = "cached.lua",
            ["frmad.daemon"] = "daemon.lua",
            ["frmad.i3bar_out"] = "i3bar_out.lua",
            ["frmad.lemonbar_out"] = "lemonbar_out.lua"
        }
    }
}
