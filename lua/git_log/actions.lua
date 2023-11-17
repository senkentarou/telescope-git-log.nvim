local action_state = require('telescope.actions.state')

local utils = require('git_log.utilities')

local A = {}

local function git_remote(opts)
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

  return remote_base
end

local function open_remote(url)
  if vim.fn.executable('open') then
    -- open remote directly on macos
    os.execute('open ' .. url)
  else
    -- copy register
    vim.fn.setreg("+", url)
    vim.fn.setreg("*", url)
    vim.notify('copied url: ' .. url)
  end
end

A.view_commit = function(opts)
  opts = opts or {}

  return function(_)
    local selection = action_state.get_selected_entry()
    if selection == nil then
      return
    end

    local remote = git_remote(opts)
    if remote == nil then
      return
    end

    open_remote('https://github.com/' .. remote .. '/commit/' .. selection.opts.commit_hash)
  end
end

A.view_blob = function(opts)
  opts = opts or {}

  return function(_)
    local selection = action_state.get_selected_entry()
    if selection == nil then
      return
    end

    local remote = git_remote(opts)
    if remote == nil then
      return
    end

    open_remote('https://github.com/' .. remote .. '/blob/' .. selection.opts.commit_hash .. '/' .. opts.current_file)
  end
end

A.view_compare = function(opts)
  opts = opts or {}

  return function(_)
    local selection = action_state.get_selected_entry()
    if selection == nil then
      return
    end

    local remote = git_remote(opts)
    if remote == nil then
      return
    end

    open_remote('https://github.com/' .. remote .. '/compare/' .. selection.opts.commit_hash .. '^..' .. selection.opts.commit_hash)
  end
end

return A
