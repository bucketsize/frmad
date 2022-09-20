#!/usr/bin/env lua

require "luarocks.loader"

local Util = require("minilib.util")

local Fmt = {}
Fmt['time']="%s"
Fmt['cpu']="%3.0f"
Fmt['cpu_level']="%.0f"
Fmt['cpu_temp']="%3.0f"
Fmt['cpu_freq']="%4.0f"
Fmt['mem']="%3.0f"
Fmt['mem_level']="%.0f"
Fmt['snd_live']="%s"
Fmt['vol']="%3.0f"
Fmt['vol_level']="%.0f"
Fmt['gpu_mem']="%4f"
Fmt['gpu_mem_used']="%4f"
Fmt['gpu_mem_used_pc']="%3.0f"
Fmt['gpu_temp']="%d"
Fmt['gpu_sclk']="%4d"
Fmt['gpu_mclk']="%4d"
Fmt['Tdie']="%3.0f"
Fmt['net_gateway']="%s"
Fmt['net_device']="%s"
Fmt['net_proto']="%s"
Fmt['net_tx']="%f"
Fmt['net_rx']="%f"
Fmt['net_ts']="%4.0f"
Fmt['net_rs']="%4.0f"
Fmt['p_pid']="%s"
Fmt['p_pcpu']="%s"
Fmt['p_pmem']="%s"
Fmt['p_name']="%s"
Fmt['cpu_volt']="%s"
Fmt['cpu_fan']="%s"
Fmt['discio']="%d"
Fmt['discio_r']="%d"
Fmt['discio_w']="%d"
Fmt['fs_free']="%s"
Fmt['battery_status']="%s"
Fmt['battery']="%d"
Fmt['weather_temperature']="%.1f"
Fmt['weather_humidity']="%.1f"
Fmt['weather_summary']="%s"

function Fmt.formatvalue(self, k, v)
    local f = self[k]
    if not f then
        local fk = k:match("[%w_]+:([%w_]+)")
        f = self[fk]
    end
    if not k then k = "__unknown" end
    if not v then v = "__unv_"..k end
    if not f then f = "__unf_"..k end
		local vo = string.format(f, v)
		-- print("formatvalue> ", k, vo)
    return vo
	end

return Fmt
