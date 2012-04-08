_path = require 'path'
wrench = require 'wrench'
crypto = require 'crypto'
_ = require 'underscore'
cp = require 'child_process'
namespaceRoot = _path.resolve(__dirname + "/tmp/repos")

# this could change into a path to the binary
_gitPath = "git"

class Git
  generateNamespacedPath: (callback) ->
    callback = _.bind callback, @
    crypto.randomBytes 16, (err, buf) ->
      randomDirName = buf.toString('hex')
      callback _path.resolve(_path.join(namespaceRoot, randomDirName))

  constructor: (@repo) ->
    @repo = _path.resolve @repo

  runCmd: (cmd, callback) ->
    # turn git status HEAD into ['status', 'HEAD']
    args = _.rest(cmd.split(' '))
    git = cp.spawn _gitPath, args, {cwd: @namespacedPath, env: {}}
    result = ''

    git.stdout.setEncoding "utf8"
    git.stdout.on 'data', (data) -> result += data
    git.stderr.on 'data', (data) -> console.log("error: " + data)
    git.on 'exit', =>
      callback null, result
      @teardownRepo()

  namespaced: (callback) ->
    @generateNamespacedPath (path) =>
      @namespacedPath = path
      @setupRepo path, =>
        callback()
        # @teardownRepo(path)

  setupRepo: (targetPath, callback) ->
    wrench.copyDirRecursive @repo, targetPath, callback


  teardownRepo: ->
    wrench.rmdirSyncRecursive @namespacedPath
    


module.exports = Git
