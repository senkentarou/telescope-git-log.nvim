local finders = require('telescope.finders')
local utils = require('git_log.utilities')

-- private
local latest_prompt = nil

-- git log --format="%C(auto)%H %as %C(green)--%Creset %s"
--
-- ex:
-- <commit_hash> <date> -- <message>
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
      prompt = latest_prompt,
    },
  }
end

-- global
local F = {}

F.set_latest_prompt = function(value)
  latest_prompt = value
end

F.content_finder = function(opts)
  opts = opts or {}

  return finders.new_job(function(prompt)
    local command = {
      'git',
      'log',
      '--format=%C(auto)%H %as %C(green)___%Creset %s',
    }

    if prompt and prompt ~= "" then
      table.insert(command, "-G")
      table.insert(command, prompt)
    end

    local current_file = opts.current_file
    if current_file and current_file ~= "" then
      table.insert(command, '--follow')
      table.insert(command, opts.current_file)
    end

    F.set_latest_prompt(prompt)

    return vim.tbl_flatten(command)
  end, entry_marker)
end

return F
