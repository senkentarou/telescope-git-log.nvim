local builtin = require('telescope._extensions.git_log_builtin')

return require('telescope').register_extension {
  exports = {
    list_commits_on_file = builtin.list_commits_on_file
  },
}
