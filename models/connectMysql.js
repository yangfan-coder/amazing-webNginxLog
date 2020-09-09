var mysql  = require('mysql');

function connectMysql (data = []) {
  var connection = mysql.createConnection({
    host     : '127.0.0.1',
    user     : 'root',
    password : 'test1234567890',
    database : 'monitoringLogs'
  });
  
  connection.connect((err) => {
    // if(err) throw err;
    console.log("Mysql Connect...");
  });
   
  
  var values = data;

  console.log('insert data', data);
  
  var sql = "INSERT INTO `monitoringLogs`.`log_table` (`prject_id`, `user_id`, `log_type`, `ua_info`, `date`, `key_name`,`key_id`, `key_self_info`, `error_type`, `error_type_info`, `error_stack_info`, `target_url`) VALUES ?";
  
  connection.query(sql, [values], function (err, rows, fields) {
    if(err){
                console.log('INSERT ERROR - ', err.message);
                return;
            }
            console.log("INSERT SUCCESS");
  });
  
  
   
  connection.end();
}

module.exports = connectMysql;
