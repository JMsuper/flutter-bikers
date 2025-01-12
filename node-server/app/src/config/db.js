const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  multipleStatements: true
});

// 연결 재시도 로직
function handleDisconnect() {
  connection.on('error', function(err) {
    if(err.code === 'PROTOCOL_CONNECTION_LOST') {
      console.log('DB 연결이 끊겼습니다. 재연결을 시도합니다...');
      handleDisconnect();
    } else {
      throw err;
    }
  });
}

handleDisconnect();

// 연결 확인
connection.connect(function(err) {
  if (err) {
    console.error('DB 연결 실패:', err);
    setTimeout(handleDisconnect, 5000);
  } else {
    console.log('DB 연결 성공');
  }
});

module.exports = connection;