_path = require 'path'
wrench = require 'wrench'
crypto = require 'crypto'
_ = require 'underscore'
cp = require 'child_process'
namespaceRoot = _path.resolve(__dirname + "/tmp/repos")
sequence = require 'sequence'

# this could change into a path to the binary
_gitPath = "git"

# use Futures sequence to clean up callback spaghetti
# TODO:
#   make target be a tar package instead of a dir
runCommand = (target, command, cb) ->
  sequence()
    .then (next) ->
      generateNamespaceName next

    .then (next, err, res) ->
      destination = resolveRepoPath res
      next err, destination

    .then (next, err, destination) ->
      setupRepo target, destination, (err, res) ->
        next err, destination

    .then (next, err, destination) ->
      _runCommand destination, command, (err, result) ->
        next destination, err, result

    .then (next, destination, err, result) ->
      teardownRepo destination, (e, r) ->
        cb err, result



# use normal 'callback' structure
runCommandCallbacks = (target, command, cb) ->
  generateNamespaceName (err, res) ->
    if err
      cb err
    else
      # turn the random name into a full path
      destination = _path.resolve(_path.join(namespaceRoot, res))

      setupRepo target, destination, (err, res) ->
        if err
          cb err
        else
          _runCommand destination, command, (giterr, result) ->
            teardownRepo destination, (err, res) ->
              cb giterr, result


# Usage:
#
#   generateNamespaceName(function(err, data) { console.log(data} ); 
generateNamespaceName = (cb) ->
  crypto.randomBytes 16, (err, buf) ->
    if err?
      cb err
    else
      randomDirName = buf.toString('hex')
      cb null, randomDirName

# Usage:
#
#   setupRepo('/repos/1', '/repos/2', function(err, data) { console.log(data) })
setupRepo = (target, destination, callback) ->
  wrench.copyDirRecursive target, destination, callback


# Usage:
#
#   _runCommand('/repos/1', 'git status', function(err, res) { console.log(res) });
_runCommand = (targetRepo, command, callback) ->
  args = _.rest(command.split(' '))
  git = cp.spawn _gitPath, args, {cwd: targetRepo, env: {}}
  result = ''
  err = ''

  git.stdout.setEncoding "utf8"
  git.stdout.on 'data', (data) -> result += data
  git.stderr.on 'data', (data) -> err += data
  git.on 'exit', =>
    if err.length
      callback err
    else
      callback null, result


# Resolves the full path to the repo with name
resolveRepoPath = (name) ->
  _path.resolve(_path.join(namespaceRoot, res))

# Usage:
#
#   teardownRepo('/repos/1', function(err, data) { console.log(data) });
teardownRepo = (targetRepo, callback) ->
  wrench.rmdirSyncRecursive targetRepo
  callback()

module.exports.runCommand = runCommand
