path = require 'path'
chai = require("chai")
global.should = chai.should()
global.assert = chai.assert
root = path.normalize(path.join(__dirname,"..")) + "/"

TESTROOT = root + "test/"
global.SRC = root + "src/"
# global.FIXTURES = test + "fixtures"

global.require_test = (file) ->
  module_path = file.replace(TESTROOT,"")
  require path.join(SRC,module_path)
