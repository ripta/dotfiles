local Module = {}

function Module.is_executable(name)
  return vim.fn.executable(name) > 0
end

function Module.has(feature)
  return vim.fn.has(feature) == 1
end

return Module
