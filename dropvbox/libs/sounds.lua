local dir = "audio/"

local sounds = {
  backmusic = love.audio.newSource(dir .. "backmusic.wav", "stream"),
  gameover = love.audio.newSource(dir .. "gameover.wav", "stream"),
  landbox = love.audio.newSource(dir .. "landbox.wav", "stream"),
  collision = {}
}

for i = 1, 3 do
  table.insert(sounds.collision, love.audio.newSource(dir .. "collision" .. i .. ".wav", "stream"))
end

function sounds.playCollisionSound()
  local randomSound = math.random(#sounds.collision)
  sounds.collision[randomSound]:play()
end

return sounds
