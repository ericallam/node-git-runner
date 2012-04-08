Git = require('..')


exports.testRunCmdSuccess = (test) ->
  runner = new Git(__dirname + "/repos/1")

  runner.namespaced ->
    runner.runCmd "git status", (err, res) ->
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

      test.equal res.trim(), status.trim()
      test.done()
