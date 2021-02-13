function love.load()
  --[[
  socket = require("socket")
  udp = socket.udp()
  udp:setsockname("*", 8080)
  udp:settimeout(0)
  --]]

  xUser = {}
  xUser.tilemap = {
    {0, 1, 0, 1, 0},
    {0, 1, 0, 1, 0},
    {0, 1, 0, 1, 0}
  }

  --[[
  world = {}

  running = true
  print("Beginning server loop.")
  --]]
end

function love.update(dt)
   


  --[[
  while (running) do
    data, msg_ip, port_nil = udp:receivefrom()

    if (data) then
      entity, cmd, params = data:match("^(%S*) (%S*) (.*)")

      if (cmd == "move" ) then
        local x, y = params:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
        assert(x and y)
        x, y = tonumber(x), tonumber(y)
        local ent = world[entity] or {x = 0, y = 0}
        world[entity] = {x = ent.x + x, y = ent.y + y}
      elseif (cmd == "at") then
        local x, y = params:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
        assert(x and y)
        x, y = tonumber(x), tonumber(y)
        world[entity] = {x = x, y = y}
      elseif (cmd == "update") then
        for k, v in pairs(world) do
          udp:sendto(string.format("%s %s %d %d", k, "at", v.x, v.y), msg_ip, port_nil)
        end
      elseif (cmd == "quit") then
        running = false
      else
        print("unrecognized command: " .. cmd)
      end
    elseif (msg_ip ~= "timeout") then
      error("Unknown network error: " .. tostring(msg))
    end

    socket.sleep(0.01)
  end

  print("Thank you")
  --]]
end

function love.draw()
  for i, row in ipairs(xUser.tilemap) do
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
end
