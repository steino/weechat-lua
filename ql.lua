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

QL = {
	["VERSION"] = "0.1",
	["AUTHOR"] = "steino",
	["LICENSE"] = "Apache-2.0",
	["DESC"] = "Nowplaying script for Quodlibet",
	["NAME"] = "np_quodlibet"
}

function parse(file)
	local out = {}
	file = io.open(file, "r")
	if file then
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
	else
		return nil
	end
end

function np(data, buffer, args)
	local int = weechat.buffer_get_integer(buffer, "number")
	local data = parse(os.getenv("HOME") .. "/.quodlibet/current")
	local artist
	if data then
		if data["albumartist"] and data["artist"] ~= data["albumartist"] then
			artist = data["albumartist"] .. ", " .. data["artist"]
		else
			artist = data["artist"]
		end
		
		if int == 1 then
			weechat.print(buffer, string.format("np: %s - [%s] %s (%s/%s)", artist, data["album"], data["title"], data["ttime"], data["format"]:lower()))
		else
			weechat.command(buffer, string.format("np: %s - [%s] %s (%s/%s)", artist, data["album"], data["title"], data["ttime"], data["format"]:lower()))
		end
	else
		weechat.print(buffer, "Could not open file, is quodlibet running?")
	end
end

weechat.register(QL["NAME"], QL["AUTHOR"], QL["VERSION"], QL["LICENSE"], QL["DESC"], "", "")
weechat.hook_command("np", "Prints the current song to current buffer.", "", "", "", "np", "")
