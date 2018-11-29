require('dotenv').config();
const mongoUsername = process.env.MONGO_USER;
const mongoPassword = process.env.MONGO_PASS;
const dbName = process.env.DB_NAME

const MongoClient = require('mongodb').MongoClient;


// references to helpful mongo vars
let client;
let db;

// This is the main resource
let dictionary;

module.exports.getDictionary = async () => {
  if (client && dictionary) return dictionary;
  else {
    try {
      await _connect();
      return dictionary;
    } catch (e) {
      console.error(e);
    }
  }
}

module.exports.closeConnection = async () => {
  if (client) {
    console.log('closing...');
    await client.close();
    console.log('closed.');
  }
  dictionary = db = client = null;
  return;
}

const _connect = async () => {
  const uri = `mongodb://${mongoUsername + ':' + mongoPassword}@cluster0-shard-00-00-pg9ez.gcp.mongodb.net:27017,cluster0-shard-00-01-pg9ez.gcp.mongodb.net:27017,cluster0-shard-00-02-pg9ez.gcp.mongodb.net:27017/${dbName}?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true`
  console.log(`connecting...`);
  client = await MongoClient.connect(uri, {useNewUrlParser: true});
  console.log('connected to client.')
  const db = client.db(dbName);
  dictionary = db.collection('dictionary');
}

