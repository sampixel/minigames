local dir = "audio/"

local sound = {
  explosion = love.audio.newSource(dir .. "explosion.wav", "stream"),
  laser = love.audio.newSource(dir .. "laser.wav", "stream"),
  ouch = love.audio.newSource(dir .. "ouch.wav", "stream"),
  scream = love.audio.newSource(dir .. "final-scream.ogg", "stream")
}

return sound
