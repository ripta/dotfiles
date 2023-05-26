return function()
  if not vim.o.modifiable then
    return ""
  end

  local linenum = nil
  for i = 1, vim.fn.line('$') do
    local linetext = vim.fn.getline(i)
    local idx = vim.fn.match(linetext, [[\v\s+$]])

    if idx ~= -1 then
      linenum = i
      break
    end
  end

  if linenum ~= nil then
    return string.format('[%d]tr', linenum)
  end
  return ''
end
