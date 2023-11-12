local previewers = require('telescope.previewers')

local P = {}

P.content_previewer = function()
  return previewers.new_termopen_previewer({
    title = 'diff changes on commit hash',
    get_command = function(entry)
      local commit_hash = entry.opts.commit_hash
      local prompt = entry.opts.prompt
      local command = {
        'git',
        'diff',
        string.format('%s~', commit_hash),
        commit_hash,
      }

      if prompt and prompt ~= "" then
        table.insert(command, "-G")
        table.insert(command, prompt)
      end

      return command
    end,
  })
end

return P
