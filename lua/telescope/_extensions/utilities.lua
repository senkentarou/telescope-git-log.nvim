local U = {}

U.split_string = function(value, separator)
  separator = separator or '%s'

  local t = {}
  for v in string.gmatch(value, '([^' .. separator .. ']+)') do
    table.insert(t, v)
  end

  return t
end

U.relative_path = function(bufnr)
  return vim.fn.expand('#' .. bufnr .. ':~:.')
end

U.run = function(command)
  local handle = io.popen(command)

  if handle then
    local result = handle:read("*a")
    handle:close()

    return string.gsub(result, '\n', ' ')
  end

  return ''
end

return U
