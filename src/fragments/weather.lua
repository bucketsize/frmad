require "luarocks.loader"

local json = require("minilib.json")
local http_request = require("http.request")

local OpenWeatherApi="http://api.openweathermap.org/data/2.5/weather?q=bengaluru&appid=%s"
local OpenWeatherApiKey=os.getenv("openweathermap_apikey")

function weather()
	local headers, stream = assert(http_request
		.new_from_uri(string.format(OpenWeatherApi, OpenWeatherApiKey))
		:go())
	local body = assert(stream:get_body_as_string())
	if headers:get ":status" ~= "200" then
		print("OpenWeatherApi Error:", body)
		return 0,0,"?"
	end
	local res = json.decode(body)
	local temperature = tonumber(res["main"]["temp"]) - 273.15
	local summary = res["weather"][1]["description"]
	local humidity = tonumber(res["main"]["humidity"])
	return temperature, humidity, summary
end
function co_weather()
	while true do
		local t,h,s=weather()
		MTAB['weather_temperature']=t
		MTAB['weather_humidity']=h
		MTAB['weather_summary']=s
		coroutine.yield()
	end
end
return {fn=weather, co=co_weather, ri=200}
