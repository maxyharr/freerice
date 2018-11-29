// Had to run dedup keys initially in order to send to mongo
module.exports = () => {
  var dict = require('../seed.json');
  var newDict = {};
  Object.keys(dict).forEach(k => newDict[k] = dict[k]);
  return newDict;
}