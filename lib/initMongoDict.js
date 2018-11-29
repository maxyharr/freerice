const mongoConnect = require('../modules/mongoConnect');
(async () => {
  let dictionary = await mongoConnect.getDictionary();

  const dictObj = require('./fetchDedupedDictionary')();
  console.log('inserting...')
  let i = 0;
  Object.keys(dictObj).forEach(k => {
    dictionary.deleteMany({_id: k});
    const doc = {_id: k, answer: dictObj[k]}
    console.log(`${i++}.`, doc);
    dictionary.insertOne(doc);
  });
  console.log('========== done ===========');
  mongoConnect.closeConnection();
})();