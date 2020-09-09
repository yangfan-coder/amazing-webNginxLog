
const Db = require('./db');

Db
  .authenticate()
  .then(() => {
    console.log('小老弟，链接成功了');
  })
  .catch(err => {
    console.error('报错：', err);
  });
  
module.exports = Db;