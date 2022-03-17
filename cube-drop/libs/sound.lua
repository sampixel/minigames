local audio = love.audio
local source = audio.newSource
local dir = "audio/"

local sound = {
  collision = {},
  cube_tap = source(dir .. "box_tap.wav", "stream"),
  switch = source(dir .. "switch.wav", "stream"),
  over = source(dir .. "game_over.wav", "stream")
}

for i = 1, 3 do
  table.insert(sound.collision, source(dir .. "collision_" .. i .. ".wav", "stream"))
end

function sound.playCollision()
  audio.play(sound.collision[love.math.random(#sound.collision)])
end

return sound
