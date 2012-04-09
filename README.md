## Node Git Runner

This node package will run git commands against a sandboxed git repo and return the result.


### Installation

Clone this repo and use npm to install the package:

    npm install path/to/this/repo

Require it:

```javascript
var git = require('git-runner');
```


### Usage

Pass the full path of an existing git repo and the command you want to run, and provide a callback:

```javascript

git.runCommand '/full/path/to/existing/git/repo', 'git status', function(err, result) {
  console.log("Error: " + err);
  console.log("Result: " + result);
});

```

### Running Tests

Pull down this repo and run:

    > npm install
    > npm test

### TODO:

 * Better handle errors
 * Ability to provide a path to an existing repo that is gzipped
 * Ability to run multiple commands in sequence and get results

