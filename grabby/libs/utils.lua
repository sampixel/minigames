local utils = {}

function utils.enable(table, field) -- enable table field
  for k, v in pairs(table) do
    v = (k == field and true or false)
    print(k, v)
  end
  print("------------------")
end

return utils
