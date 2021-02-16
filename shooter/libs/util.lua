local util = {}

function util.checkDistance(object, other)
  if (math.sqrt((other.y - object.body:getY())^2 + (other.x - object.body:getX())^2) <= object.shape:getRadius()) then
    return true
  end
  return false
end

return util
