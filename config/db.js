
const Sequelize = require('sequelize');

/**
 * 数据库配置项【https://sequelize.org/v5/class/lib/sequelize.js~Sequelize.html#instance-constructor-constructor】
 *  
 * @typedef {Object} MySql
 * @property {string} host 数据库的IP地址
 * @property {string} user // 数据库用户名
 * @property {string} password // 数据库密码
 * @property {string} database // 数据库名称
 * @property {string} dialect // 数据库类型【mysql，postgres，sqlite和mssql之一。】
 * @property {string} port // 数据库端口
 * @property {Object} pool    // 排序连接池配置
 */

const sqlConfig = {
  host: "localhost",
  user: "root", 
  password: "xxxxxxx", 
  database: "monitoringLogs" 
};

const sequelize = new Sequelize(sqlConfig.database, sqlConfig.user, sqlConfig.password, {
  host: sqlConfig.host,
  dialect: 'mysql', 
  port:'3306',  
  pool: {
    max: 100, // 池中的最大连接数
    min: 10,  // 池中的最小连接数
    acquire: 30000, // 该池在抛出错误之前将尝试获得连接的最长时间（以毫秒为单位）
    idle: 10000 // 连接释放之前可以空闲的最长时间（以毫秒为单位）。
  }
});

module.exports = sequelize;
