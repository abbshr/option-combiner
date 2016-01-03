require('coffee-script/register');
var dirname = require('path').dirname(module.parent.filename);
module.exports = require('./lib')(dirname);
