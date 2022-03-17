local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local player = {
  filename = "player-sprite-sheet.png",
  x = cw / 2,
  y = ch / 2,
  scale = {x = 0.5, y = 0.5},
  speed = {x = 200, y = 200},
  frame = {
    current = 9,
    first = 9,
    last = 12,
    rows = 4,
    cols = 4
  },
  button = {
    top = "k",
    bottom = "j",
    right = "l",
    left = "h"
  },
  sequence = {
    top = {
      idle = {from = 5, to = 8},
      walk = {from = 5, to = 8}
    },
    bottom = {
      idle = {from = 1, to = 4},
      walk = {from = 1, to = 4}
    },
    right = {
      idle = {from = 13, to = 16},
      walk = {from = 13, to = 16}
    },
    left = {
      idle = {from = 9, to = 12},
      walk = {from = 9, to = 12}
    }
  }
}

return player
