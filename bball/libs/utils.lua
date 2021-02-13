local utils = {

  tilemap = {
    [1] = { -- level 1
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
      {1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1},
      {1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1},
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    },
    [2] = { -- level 2
    },
    [3] = {},
    [4] = {}
  }
}

function utils.checkindex(tbl, value, audio)
  local index
  audio:play()

  for i = 1, #tbl do
    if (tbl[i].xscale == 2) or (tbl[i].yscale == 2) then
      tbl[i].xscale = 1
      tbl[i].yscale = 1
      index = i
      break
    end
  end

  if (value == 1) then
    if (index + 1 == #tbl + 1) then
      index = 1
    else
      index = index + 1
    end
  elseif (value == 0) then
    if (index - 1 == 0) then
      index = 3
    else
      index = index - 1
    end
  end

  tbl[index].xscale = 2
  tbl[index].yscale = 2
end

return utils
