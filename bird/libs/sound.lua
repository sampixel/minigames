local audio = love.audio
local snd_dir = "audio/"
local mode = "stream"

audio.setVolume(0.3)

return {
  flap = audio.newSource(snd_dir .. "flap.wav", mode),
  score = audio.newSource(snd_dir .. "score.wav", mode),
  crash = audio.newSource(snd_dir .. "crash.wav", mode),
  switch = audio.newSource(snd_dir .. "switch.wav", mode),
  play = audio.newSource(snd_dir .. "play.wav", mode),
  music = audio.newSource(snd_dir .. "music.wav", mode)
}
