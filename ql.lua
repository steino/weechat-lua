--[[
License:
Copyright 2010 Stein-Ivar Berghei (irc:steino@freenode)
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

function parse(file)
	local out = {}
	file = assert(io.open(file, "r"))
	for line in file:lines() do
		for i,v in line:gmatch("(%a+)=(.+)") do
			out[i] = v
		end
	end
	local min = string.format("%1.f", math.floor(out["length"]/60))
	local sec = string.format("%02.f", math.floor(out["length"]-(min*60))) 
	out["ttime"] =  min .. ":" .. sec
	file:close()

	return out
end

function np(data, buffer, args)
	local int = weechat.buffer_get_integer(buffer, "number")
	local data = parse(os.getenv("HOME") .. "/.quodlibet/current")
	if int == 1 then
		weechat.print(buffer, string.format("np: %s - [%s] %s (%s/%s)", data["artist"], data["album"], data["title"], data["ttime"], data["format"]))
	else
		weechat.command(buffer, string.format("np: %s - [%s] %s (%s/%s)", data["artist"], data["album"], data["title"], data["ttime"], data["format"]))
	end
end

weechat.register("np_quodlibet", "steino", "0.1", "Apache-2.0", "Nowplaying script for Quod Libet", "", "")
weechat.hook_command("np",
"Prints the current song to current buffer.",
"",
"",
"",
"np",
"")
