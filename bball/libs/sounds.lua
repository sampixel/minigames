local sounds = {}
local dir = "audio/"

sounds.switch = love.audio.newSource(dir .. "switch.wav", "stream")

return sounds
