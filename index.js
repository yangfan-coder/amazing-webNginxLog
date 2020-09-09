const fs = require("fs");
const readline = require("readline");
const getLogInfo = require("./models");

/**
 * _对象的封装 初始变量
 *
 * @typedef {Object} _
 * @property {null} setLineAll 存储的全部文件流
 * @property {null} getLineAll 获取全部的文件流
 * @property {Array} logAll 存储读取完成的所有日志
 * @property {Array} filterResult 过滤错误日志拿到的结果
 * @property {Array} checkStream 比对的错误的日志数组
 * @property {Array} results 最终获取的日志arr
 * @property {Array} logAll 存储读取完成的所有日志
 */

let date = new Date();

const _ = {
  setLineAll: null,
  getLineAll: null,
  logAll: [],
  filterResult: [],
  checkStream: [],
  results: [],
  timeLine: parseInt(`${date.getHours()}${date.getMinutes()}`, 10) - 5   // 小于当前时间5分钟的文件
};

// 读取文件路径【分钟维度】
const MINUTE = "/data/nginx_log/logs/access_minute";

// 同步读取文件的路径的所有文件日志
const AllJournal = fs.readdirSync(MINUTE);

/**
 * 自执行函数 => init 同步进行入库操作
 *
 */

(async () => {
  let filterArr = [];
  AllJournal.forEach((item)=> { 
    let arr = /\d{4}-\d{2}-\d{2}-(\d{2}:\d{2})-access/.exec(item);
    let fileTime = parseInt(arr[1].replace(':', ''), 10);

    console.log('文件时间：',fileTime, _.timeLine)

    if (fileTime > _.timeLine) {
      filterArr.push(`${MINUTE}/${item}`);
    }
  })

  _.results = filterArr.map(async item => {
    console.log('筛选出的文件名：', item);
    _.getLineAll = await readLines(item);

    _.filterResult = await filterErrorLog();

    return _.filterResult;
  });
  
  if (!_.results.length) return;
  
  const numFruits = await Promise.all(_.results);
  getLogInfo(numFruits[0]);
})();

/**
 * 创建二进制流、读取文件
 *
 * @return {Object} setLineAll  返回全部读取的文件信息
 *
 */
async function readLines(_file) {
  const getData = fs.createReadStream(_file);

  const rl = readline.createInterface({
    input: getData, // 监听可读流
    crlfDelay: Infinity // \r \n 延迟时间，默认是100
  });

  for await (const line of rl) {
    _.setLineAll = await getInfo(line);
  }

  return _.setLineAll;
}

/**
 * 没读取一行日志信息、对每行进行正则提取
 *
 * @return {Object} logAll  [{},{},{}..]  返回日志的入库格式
 *
 */

function getInfo(url) {
  // 为了兼容正则表达式最后的&匹配
   url = `${url}&`;

   console.log('log file line', url);
  const arr_log = [
    "prject_id",
    "user_id",
    "log_type",
    "ua_info",
    "date",
    "key_name",
    "key_id",
    "key_self_info",
    "error_type",
    "error_type_info",
    "error_stack_info",
    "target_url"
  ];
  const reChek = arr_log
    .map(item => {
      const itemRe = new RegExp(`${item}.*?(?=&)`, "g");
      return url.match(itemRe)[0];
    })
    .map(item => {
      let _key = item.split("=")[0];
      let _val = item.split("=")[1];
      return {
        [_key]: _val
      };
    });

  // 处理字段资源
  const checkLogList = {};

  reChek.forEach(item => {
    Object.assign(checkLogList, item);
  });

  // 存储原始的数据流
  _.logAll.push(checkLogList);

  return _.logAll;
}

/**
 * 过滤错误日志的去重，【 prject_id、 error_type】
 *
 * @return {Object} checkStream  返回去重之后的结果数组
 *
 */

function filterErrorLog() {
  _.getLineAll.forEach(item => {
    if (!_.checkStream.length) _.checkStream.push(item);

    for (let i = 0; i < _.checkStream.length; i++) {
      if (
        item.prject_id === _.checkStream[i].prject_id &&
        item.error_type === _.checkStream[i].error_type && 
        item.error_stack_info === _.checkStream[i].error_stack_info
      )
        break;

      if (i === _.checkStream.length - 1) {
        _.checkStream.push(item);
      }
    }
  });
  return _.checkStream;
}
