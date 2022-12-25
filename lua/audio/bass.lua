local class = require("pl.class")
local const = require("audio.bass.constants")
local ffi = require("ffi")
local stream = require("audio.bass.stream")

class.BASS()

function BASS:_init()

  self.bass = require("audio.bindings.bass")

end

function BASS:Free()

  self.bass.BASS_Free()

  return self.bass.BASS_ErrorGetCode()

end

function BASS:GetConfig(option)

  return self.bass.BASS_GetConfig(option)

end

function BASS:GetVersion()

  version = self.bass.BASS_GetVersion()

  return version

end

function BASS:Init(device, frequency, flags)

  device = device or -1

  frequency = frequency or 44100

  flags = flags or 0

  f=self.bass.BASS_Init(device, frequency, flags, nil, nil)
  return self.bass.BASS_ErrorGetCode()
end

function BASS:SetConfig(option, value)

  self.bass.BASS_SetConfig(option, value)

  return self.bass.BASS_ErrorGetCode()

end

function BASS:StreamCreate(freq, chans, flags)

  local handle = self.bass.BASS_StreamCreate(freq, chans, flags, -1, nil)

  if self.bass.BASS_ErrorGetCode() ~= const.error.ok then
    return self.bass.BASS_ErrorGetCode()
  else
    return stream(handle)
  end
end
function BASS:StreamCreateUrl(url,offset,flags)
offset = offset or 0
  flags = flags or 0
  assert(type(url)=="string")
    local sfile = ffi.new("char[?]", #url+1)
  ffi.copy(sfile, url)
local handle = self.bass.BASS_StreamCreateURL(sfile, offset, flags,nil)
--local handle=2
if handle == 0 then
    return self.bass.BASS_ErrorGetCode()
  else
    return stream(handle)
  end
end

function BASS:StreamCreateFile(mem, file, offset, length, flags)
  offset = offset or 0
  length = length or 0
  flags = flags or 0

  assert(type(mem) == 'boolean')

  local sfile = ffi.new("char[?]", #file+1)
  ffi.copy(sfile, file)

  local handle = self.bass.BASS_StreamCreateFile(mem, sfile, offset, length, flags)

  if handle == 0 then
    return self.bass.BASS_ErrorGetCode()
  else
    return stream(handle)
  end

end

function BASS:PluginLoad(filename)
	local sfile = ffi.new("char[?]", #filename+1)
	ffi.copy(sfile, filename)
	local handle=self.bass.BASS_PluginLoad(sfile)
	if handle == 0 then
    return self.bass.BASS_ErrorGetCode()
  else
    return handle
  end

 end
 function BASS:SetEnvironment(env,vol, decay, damp)
 --only works in 3d audio mode
   local result=self.bass.BASS_SetEAXParameters(env,vol,decay,damp)
   if not result then
return self.bass.BASS_ErrorGetCode()
else
return true  
end
end
  
return BASS