local object = {}


object["player"] = {
  filename = "player",
  speed = 300,
  update = function(self, dt)
    if (love.keyboard.isDown("h")) then
      self.x = self.x - self.speed * dt
    elseif (love.keyboard.isDown("l")) then
      self.x = self.x + self.speed * dt
    end
  end
}


return object
