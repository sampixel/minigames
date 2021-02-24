local util = {}


function util.checktable(tbl, dt)
  for i, _ in ipairs(tbl) do
    tbl[i]:update(dt)

    if ((tbl[i].y + tbl[i].height <= 0) or (tbl[i].y >= love.graphics.getHeight())) then
      table.remove(tbl, i)
    end
  end
end


function util.draw(tbl)
  for i, _ in ipairs(tbl) do
    tbl[i]:draw()
  end
end


function util.collision(tbl, obj)
  for i, _ in ipairs(tbl) do
    if (tbl:collision(obj)) then
      table.remove(tbl, i)
    end
  end
end


return util
