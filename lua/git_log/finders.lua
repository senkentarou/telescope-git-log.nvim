local finders = require('telescope.finders')
local utils = require('git_log.utilities')

-- git log --format="%H %as ___ %s"
--
-- ex:
-- <commit_hash> <date> ___ <message>
local entry_marker = function(entry)
  local splits = utils.split_string(entry, '___')

  local attrs = utils.split_string(splits[1], '%s')
  local commit_hash = attrs[1]
  local date = attrs[2]

  local message = splits[2]

  return {
    value = entry,
    display = date .. ':' .. message,
    ordinal = date .. ':' .. message,
    opts = {
      commit_hash = commit_hash,
      date = date,
      message = message,
    },
  }
end

local F = {}

F.content_finder = function(opts)
  opts = opts or {}

  return finders.new_job(function(_)
    local command = {
      'git',
      'log',
      '--format=%H %as ___ %s',
    }

    local current_file = opts.current_file
    if current_file and current_file ~= "" then
      table.insert(command, '--follow')
      table.insert(command, current_file)
    end

    return vim.tbl_flatten(command)
  end, entry_marker)
end

return F
