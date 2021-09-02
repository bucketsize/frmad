local socket = require("socket")
while true do
	io.write(os.date().."\n")
	io.flush()
	socket.sleep(1)
end



