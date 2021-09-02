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
}
build = {
	type = "none",
	install = {
		lua = {
		  ["frmad.formats"] = "src/config/formats.lua",
		  ["frmad.alerts"] = "src/config/alerts.lua",

		  ["frmad.amdgpu"] = "src/fragments/amdgpu.lua",
		  ["frmad.battery"] = "src/fragments/battery.lua",
		  ["frmad.cpu"] = "src/fragments/cpu.lua",
		  ["frmad.cpu_freq"] = "src/fragments/cpu_freq.lua",
		  ["frmad.cpu_temp"] = "src/fragments/cpu_temp.lua",
		  ["frmad.disk"] = "src/fragments/disk.lua",
		  ["frmad.mem"] = "src/fragments/mem.lua",
		  ["frmad.net"] = "src/fragments/net.lua",
		  ["frmad.process"] = "src/fragments/process.lua",
		  ["frmad.pulseaudio"] = "src/fragments/pulseaudio.lua",
		  ["frmad.weather"] = "src/fragments/weather.lua",

      ["frmad.clogger"] = "src/writers/clogger.lua",
      ["frmad.mcache"] = "src/writers/mcache.lua",
      ["frmad.mlogger"] = "src/writers/mlogger.lua",

      ["frmad.cachec"] = "src/lib/cachec.lua",
      ["frmad.sym"] = "src/lib/sym.lua",
		},
		bin = {
		  ["frmad.cached"] = "src/cached.lua",
			["frmad.daemon"] = "src/daemon.lua",
			["frmad.i3bar_out"] = "src/i3bar_out.lua",
			["frmad.lemonbar_out"] = "src/lemonbar_out.lua"
		}
	}
}
