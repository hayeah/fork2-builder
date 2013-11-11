path = require 'path'
chai = require("chai")
global.should = chai.should()
global.assert = chai.assert
root = path.normalize(path.join(__dirname,"..")) + "/"

test = root + "test/"
global.SRC = root + "src/"
global.FIXTURES = test + "fixtures"
