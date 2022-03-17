local cw = love.graphics.getWidth()
local ch = love.graphics.getHeight()
local object = {
  player = {
    filename = "sprite-sheet.png",
    num_frame_per_width = 4,
    num_frame_per_height = 9,
    busy = false,
    x = cw/3, y = cw-50,
    scale = {x = 0.5, y = 0.5},
    speed = {x = 120, y = 80},
    frame = {
      normal = {
        left =  {first = 9, last = 12},
        right = {first = 5, last = 8},
        jump =  {first = 21, last = 28},
        idle =  {first = 1, last = 4}
      },
      busy = {
        left =  {first = 17, last = 20},
        right = {first = 13, last = 16},
        jump =  {first = 21, last = 0},
        idle =  {first = 0, last = 0}
      }
    },
    action = {
      left = false, right = false,
      jump = false, idle = false
    },
    animate = function(self, mode, direction)
      if (self.current_frame >= self.frame[mode][direction].first and self.current_frame <= self.frame[mode][direction].last) then
        self.current_frame = self.current_frame
      elseif (self.current_frame > self.frame[mode][direction].last) then
        self.current_frame = self.frame[mode][direction].first
      else
        self.current_frame = self.frame[mode][direction].first
      end

      --[[
      self.current_frame = (
        (self.current_frame > self.frame[mode][direction].first and self.current_frame < self.frame[mode][direction].last) and
        self.current_frame or (self.current_frame > self.frame[mode][direction].last and self.frame[mode][direction].first)
      )
      --]]
    end,
    catch = function(self, target)
      target.catched = true
      self.busy = true
    end,
    release = function(self, target)
      local vx, _ = self.body:getLinearVelocity()
      if not (vx > 0 and vx < 0) then
        local spin = 250
        target.body:applyLinearImpulse(self.prev_direction == "left" and -spin or (self.prev_direction == "right" and spin), -spin * 2)
        target.catched = false
        self.box_index = nil
        self.busy = false
      end
    end,
    collision = function(self, target)
      for i = 1, #target do
        if (self.body:getX() - (self.frame_width / 2) < (target[i].body:getX() - (target[i].width / 2)) + target[i].width and
            target[i].body:getX() - (target[i].width / 2) < (self.body:getX() - (self.frame_width / 2)) + self.frame_width and
            self.body:getY() - (self.frame_height / 2) < (target[i].body:getY() - (target[i].height / 2)) + target[i].height and
            target[i].body:getY() - (target[i].height / 2) < (self.body:getY() - (self.frame_height / 2)) + self.frame_width) then
          self.box_index = i
          return true
        end
      end
      return false
    end,
    update = function(self, delta)
      if (love.keyboard.isDown("l")) then     -- move to right
        self.x = self.x + (self.speed.x * delta)
        self:animate(self.busy and "busy" or "normal", "right")
      elseif (love.keyboard.isDown("h")) then -- move to left
        self.x = self.x - (self.speed.x * delta)
        self:animate(self.busy and "busy" or "normal", "left")
      end

      self.body:setX(self.x)
      self.body:setAngle(0)
    end
  }
}

return object
