local class = {}

function class.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function class.load(self)
  self.image = love.graphics.newImage("images/" .. self.filename)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function class.draw(self)
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale.x, self.scale.y)
end

function class.rescale(self)
  self.width = self.width * self.scale.x
  self.height = self.height * self.scale.y
end

function class.quad(self)
  for i = 0, self.frame.num_height - 1 do
    local size = 128
    for j = 0, self.frame.num_width - 1 do
      table.insert(self.sheets, love.graphics.newQuad(
        1 + (j * size), 1 + (i * size), size - 1, size - 1,
        self.width, self.height
      ))
    end
  end
end

return class
