require "luarocks.loader"

local Home = os.getenv("HOME")

local Util = require("minilib.util")

local Cfg
if Util:file_exists(Home.."/.config/frmad/config") then
   Cfg = loadfile(Home.."/.config/frmad/config")()
else
   Cfg = require("frmad.config0")
end
return Cfg
