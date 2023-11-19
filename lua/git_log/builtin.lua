local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values

local git_log_a = require('git_log.actions')
local git_log_f = require('git_log.finders')
local git_log_p = require('git_log.previewers')
local utils = require('git_log.utilities')

local B = {}

B.list_commits_on_file = function(opts)
  opts = opts or {}
  opts.bufnr = vim.fn.bufnr()
  opts.current_file = utils.relative_path(opts.bufnr)

  if opts.current_file == '' then
    vim.notify('current file is empty.')
    return
  end

  pickers.new(opts, {
    results_title = 'commits on ' .. opts.current_file,
    prompt_title = '<C-y>:copy/<C-o>:blob/<C-p>:compare/<CR>:commit/<C-q>:quit',
    finder = git_log_f.content_finder(opts),
    previewer = git_log_p.content_previewer(),
    sorter = config.file_sorter(opts),
    attach_mappings = function(_, map)
      map('n', 'y', git_log_a.copy_hash)
      map('n', 'o', git_log_a.view_blob(opts))
      map('n', 'p', git_log_a.view_compare(opts))

      map('i', '<C-y>', git_log_a.copy_hash)
      map('i', '<C-o>', git_log_a.view_blob(opts))
      map('i', '<C-p>', git_log_a.view_compare(opts))

      -- <CR> action
      actions.select_default:replace(git_log_a.view_commit(opts))

      return true
    end,
  }):find()
end

return B
