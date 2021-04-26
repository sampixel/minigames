function love.conf(t)
  t.accelerometerjoystick = false

  t.window.title = "Multiplayer Race Game"
  t.window.icon = "images/love.png"
  t.window.highdpi = true
  t.window.fullscreen = true

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
end
