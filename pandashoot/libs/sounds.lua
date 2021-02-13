sounds = {}

local dir = "/audio/"

sounds.stop = love.audio.newSource(dir .. "stop.wav", "stream")
sounds.shot = love.audio.newSource(dir .. "shot.wav", "stream")
sounds.gotcha = love.audio.newSource(dir .. "gotcha.wav", "stream")
sounds.out = love.audio.newSource(dir .. "error.wav", "stream")

return sounds
