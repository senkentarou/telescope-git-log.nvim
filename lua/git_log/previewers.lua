local previewers = require('telescope.previewers')
local previewer_utils = require('telescope.previewers.utils')

local P = {}

P.content_previewer = function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()

  return previewers.new_buffer_previewer({
    title = 'diff changes on commit hash',
    define_preview = function(self, entry)
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

      previewer_utils.job_maker(command, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            previewer_utils.regex_highlighter(bufnr, "diff")
          end
        end,
      })
    end,
  })
end

return P
