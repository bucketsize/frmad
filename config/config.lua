require "luarocks.loader"

local Home = os.getenv("HOME")

local Sh = require("minilib.shell")

local Cfg
if Sh.file_exists(Home.."/.config/frmad/config") then
   Cfg = loadfile(Home.."/.config/frmad/config")()
else
   Cfg = require("frmad.config.config0")
end
return Cfg
