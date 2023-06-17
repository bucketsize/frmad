package = "frmad"
version = "dev-1"
source = {
	url = ".",
}
description = {
	homepage = "",
	license = "EULA",
}
dependencies = {
	"lua >= 5.3",
	"http",
}
build = {
	type = "none",
	install = {
		lua = {
			["frmad.config.config0"] = "config/config0.lua",
			["frmad.config.config"] = "config/config.lua",
			["frmad.config.formats"] = "config/formats.lua",
			["frmad.config.alerts"] = "config/alerts.lua",

			["frmad.fragments.amdgpu"] = "fragments/amdgpu.lua",
			["frmad.fragments.nvgpu"] = "fragments/nvgpu.lua",
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
			["frmad.writers.lemonbar"] = "writers/lemonbar.lua",
			["frmad.writers.i3bar"] = "writers/i3bar.lua",

			["frmad.lib.cachec"] = "lib/cachec.lua",
			["frmad.lib.sym"] = "lib/sym.lua",
			["frmad.lib.process_metrics"] = "lib/process_metrics.lua",

			["frmad.interfaces.tcp"] = "interfaces/tcp.lua",
		},
		bin = {
			["frmad.cached"] = "cached.lua",
			["frmad.daemon"] = "daemon.lua",
		},
	},
}
