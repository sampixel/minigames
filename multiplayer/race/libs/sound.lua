local sound = {
  impact = love.audio.newSource("audio/impact.wav", "stream"),
  reward = love.audio.newSource("audio/reward.wav", "stream"),
  engine = love.audio.newSource("audio/engine.wav", "stream"),
  background = love.audio.newSource("audio/background.wav", "stream")
}

return sound
