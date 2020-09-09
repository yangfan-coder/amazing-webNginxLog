const logTable = require('./logTable');
const tranferData = function (log) {
  let values = [];

  log.forEach((item, key) => {
    let arr = [];
    for (var i in  item) {
      arr.push(item[i])
    }
    values.push(arr);
  });

  return values;
}
// 获取用户传递的参数信息
const getLogInfo = function (log) {
  logTable.bulkCreate(tranferData(log))
}

/*  模拟数据源 */


// logTable.bulkCreate([
//   {
//     prject_id: 'ceshi11111111111',
//     user_id: 'ceshi',
//     log_type: 'c',
//     ua_info: 'ceshi',
//     date: '20180111',
//     key_name: 'ceshi',
//     key_self_info: 'ceshi',
//     error_type: 'ceshi',
//     error_type_info: 'ceshi',
//     error_stack_info: 'ceshi',
//     target_url: 'ceshi',
//     key_id: 'ceshi',
//   },
//   {
//     prject_id: 'hhhhh',
//     user_id: 'ceshi',
//     log_type: 'ceshi',
//     ua_info: 'ceshi',
//     date: '20180111',
//     key_name: 'ceshi',
//     key_self_info: 'ceshi',
//     error_type: 'ceshi',
//     error_type_info: 'ceshi',
//     error_stack_info: 'ceshi',
//     target_url: 'ceshi',
//     key_id: 'ceshi',
//   }
// ])

// ;(async function (){
//   const all = await logTable.findAll();
//   console.log(all)
//   console.log('查询多条语句')
// }())

module.exports = getLogInfo

// let data = [
//     {
//       prject_id: 'ceshi11111111111',
//       user_id: 'ceshi',
//       log_type: '1',
//       ua_info: 'ceshi',
//       date: '20180111',
//       key_name: 'ceshi',
//       key_self_info: 'ceshi',
//       error_type: '1',
//       error_type_info: 'ceshi',
//       error_stack_info: 'ceshi',
//       target_url: 'ceshi',
//       key_id: 'ceshi',
//     },
//     {
//       prject_id: 'hhhhh',
//       user_id: 'ceshi',
//       log_type: '2',
//       ua_info: 'ceshi',
//       date: '20180111',
//       key_name: 'ceshi',
//       key_self_info: 'ceshi',
//       error_type: '4',
//       error_type_info: 'ceshi',
//       error_stack_info: 'ceshi',
//       target_url: 'ceshi',
//       key_id: 'ceshi',
//     }
//   ];

//   getLogInfo(data);
