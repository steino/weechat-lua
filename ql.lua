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

weechat.register("np_quodlibet", "steino", "0.1", "GPL-3", "Nowplaying script for Quod Libet", "", "")
weechat.hook_command("np",
"Prints the current song to current buffer.",
"",
"",
"",
"np",
"")
