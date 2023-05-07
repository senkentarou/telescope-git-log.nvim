local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values

local git_log_a = require('telescope._extensions.git_log_actions')
local git_log_f = require('telescope._extensions.git_log_finders')
local git_log_p = require('telescope._extensions.git_log_previewers')
local utils = require('telescope._extensions.utilities')

local B = {}

B.list_commits_on_file = function(opts)
  opts = opts or {}
  opts.bufnr = vim.fn.bufnr()
  opts.current_file = utils.relative_path(opts.bufnr)

  if opts.current_file == '' then
    vim.notify('there is no current file.')
    return
  end

  pickers.new(opts, {
    results_title = 'commits on ' .. opts.current_file,
    prompt_title = 'list commits on file',
    finder = git_log_f.content_finder(opts),
    previewer = git_log_p.content_previewer(),
    sorter = config.file_sorter(opts),
    attach_mappings = function(_, _)
      actions.select_default:replace(git_log_a.view_web(opts)) -- <CR> action

      return true
    end,
  }):find()
end

return B
