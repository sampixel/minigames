function love.load()
  --[[
  socket = require("socket")

  udp = socket.udp()
  udp:setpeername("localhost", 8080)
  udp:settimeout(0)

  math.randomseed(os.time())
  entity = tostring(math.random(99999))
  udp:send(string.format("%s %s %d %d", entity, "at", 320, 240))
  --]]
  
  oUser = {}
  oUser.tilemap = {
    {0, 1, 0, 1, 0},
    {0, 1, 0, 1, 0},
    {0, 1, 0, 1, 0}
  }

  world = {}
  rate = 0.1
  time = 0
end

function love.update(dt)
  --[[
  time = time + dt

  if (time >= rate) then
    udp:send(string.format("%s %d %s %d", "time:", time, " rate:", rate))
    time = time - rate
  end

  repeat
    data, msg = udp:receive()

    if (data) then
      ent, cmd, params = data:match("^(%S*) (%S*) (.*)")

      if (cmd == "at") then
        local x, y = params:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
        assert(x and y)
        x, y = tonumber(x), tonumber(y)
        world[ent] = {x = x, y = y}
      else
        print("unrecognized command: " .. cmd)
      end
    elseif (msg ~= "timeout") then
      error("Network error: " .. tostring(msg))
    end
  until not (data)
  --]]
end

function love.draw()
  for i, row in ipairs(oUser.tilemap) do
    for j, tile in ipairs(row) do
      if (tile ~= 0) then
        love.graphics.draw(
          love.graphics.newImage("images/verticalBar.png"),
          (love.graphics.getWidth() / 2.3) + j * 50,
          100 * i,
          0, 0.7, 3
        )
      end
    end

    if (i == 3) then
      break
    else
      love.graphics.draw(
        love.graphics.newImage("images/horizontalBar.png"),
        love.graphics.getWidth() / 2.2,
        190 + (100 * (i-1)),
        0, 3, 1
      )
    end
  end
  --[[
  for k, v in pairs(world) do
    love.graphics.print(k, v.x, v.y)
  end
  --]]
end
