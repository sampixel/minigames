local source = love.audio.newSource
local snd_dir = "audio/"
local mode = "stream"

return {
  flap = source(snd_dir .. "flap.wav", mode),
  score = source(snd_dir .. "score.wav", mode),
  crash = source(snd_dir .. "crash.wav", mode)
}
