local finders = require('telescope.finders')
local utils = require('git_log.utilities')

local function run(command)
  local handle = io.popen(command)

  if handle then
    local result = handle:read("*a")
    handle:close()

    return result
  end

  return ''
end

local make_results = function(current_file)
  -- run command, then returns the string as bellow.
  --
  -- <commit_hash>___<date>___<message>___\n\n<file_name>\n
  -- ...
  --
  local command = table.concat({
    'git',
    'log',
    "--format='%H___%as___%s___'",
    '--name-only',
    '--follow',
    current_file,
  }, ' ')

  -- formatting plan:
  --   1. remove \n\n by string.gsub
  --   2. match characters former \n iterating by string.gmatch
  --
  -- the results may format as bellow,
  --
  -- results = {
  --   { "<commit_hash>___<date>___<message>___<file_name>" },
  --   ...
  -- }
  --
  local results = {}
  for line in string.gmatch(string.gsub(run(command), '\n\n', ''), "(.-)\n") do
    table.insert(results, {
      line,
    })
  end

  return results
end

local make_entry = function(entry)
  local splits = utils.split_string(entry[1], '___')

  local commit_hash = splits[1]
  local date = splits[2]
  local message = splits[3]
  local file_name = splits[4]

  return {
    value = entry,
    display = date .. ': ' .. message,
    ordinal = date .. ': ' .. message,
    opts = {
      commit_hash = commit_hash,
      date = date,
      message = message,
      file_name = file_name,
    },
  }
end

local F = {}

F.content_finder = function(opts)
  opts = opts or {}

  return finders.new_table({
    results = make_results(opts.current_file),
    entry_maker = make_entry,
  })
end

return F
