local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local utils = require('telescope._extensions.utilities')

local A = {}

A.view_web = function(opts)
  opts = opts or {}

  return function(bufnr)
    actions.close(bufnr)

    local selection = action_state.get_selected_entry()
    if selection == nil then
      return
    end

    local target_remote = opts.remote or 'origin'
    local git_remotes = utils.run('git remote show')
    if not string.find(git_remotes, target_remote) then
      target_remote = 'origin'
    end

    -- get remote base url
    local git_remote_url = utils.run('git ls-remote --get-url ' .. target_remote)
    local url_base = string.gsub(git_remote_url, '^.-github.com[:/]?(.-)%s?$', '%1') -- only github...
    local remote_base = string.gsub(url_base, '^(.-)%.git$', '%1') -- clean .git postfix

    if git_remote_url == remote_base or #remote_base <= 0 then
      return
    end

    os.execute('open https://github.com/' .. remote_base .. '/blob/' .. selection.opts.commit_hash .. '/' .. opts.current_file)
  end
end

return A
