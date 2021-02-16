local object = {}

local CW = love.graphics.getWidth()
local CH = love.graphics.getHeight()

object["back"] = {
  filename = "back",
  xScale = 2.2,
  yScale = 2.2,
  width = CW,
  height = CH
}

object["grass"] = {
  filename = "grass",
  speed = 50,
  x = - 10,
  y = CH - 350,
  xScale = 2.5,
  yScale = 1.2,
  width = CW,
  height = CH,
  update = function(self, dt)
    if (love.keyboard.isDown("h")) then
      self.x = self.x + self.speed * dt
    elseif (love.keyboard.isDown("l")) then
      self.x = self.x - self.speed * dt
    end
  end
}

object["shooter"] = {
  filename = "shooter",
  status = "idle",
  lives = 3,
  speed = 300,
  xScale = 1, 
  yScale = 1,
  frames = {},
  current_frame = 1,
  update = function(self, dt)
    if (love.keyboard.isDown("h")) then
      self.x = self.x - self.speed * dt
      self.xScale = -1
    elseif (love.keyboard.isDown("l")) then
      self.x = self.x + self.speed * dt
      self.xScale = 1
    end 

    if (self.x - (self.frame_width/2) <= 0) then
      self.x = 0 + (self.frame_width/2)
    elseif(self.x + (self.frame_width/2) >= CW) then
      self.x = CW - (self.frame_width/2)
    end

    if (self.status == "idle") and (self.current_frame >= 6) then
      self.current_frame = 1
    elseif (self.status == "walking") and (self.current_frame >= 12) then
      self.current_frame = 7
    end
    
    self.current_frame = self.current_frame + (5 * dt)
  end
}

return object
