git = require('..')
_path = require 'path'


exports.testRunCommandsSuccess = (test) ->
  
  repoPath = _path.resolve(__dirname + "/repos/1")

  git.runCommand repoPath, "git status", (err, result) ->
    status = '''
      # On branch master
      #
      # Initial commit
      #
      # Untracked files:
      #   (use "git add <file>..." to include in what will be committed)
      #
      #	README
      nothing added to commit but untracked files present (use "git add" to track)
    '''

    test.equal result.trim(), status.trim()
    test.done()

exports.testRunCommandFailure = (test) ->
  
  repoPath = _path.resolve(__dirname + "/repos/1")

  git.runCommand repoPath, "git not-a-command", (err, result) ->
    test.equal err.trim(), "git: 'not-a-command' is not a git command. See 'git --help'."

    test.done()
