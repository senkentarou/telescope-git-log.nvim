local builtin = require('git_log.builtin')

return require('telescope').register_extension {
  exports = {
    list_commits_on_file = builtin.list_commits_on_file
  },
}
