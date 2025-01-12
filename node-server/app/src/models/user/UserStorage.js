"use strict";

const db = require("../../config/db");

class UserStorage {

  //*************************************************  GET  ***************************************************//
  static getUserInfo(id) {
    return new Promise((resolve, reject) => {
      const query = "SELECT * FROM users WHERE id = ?;";
      db.query(query, [id], (err, data) => {
        if (err) { 
          reject(`${err}`);
      }
        else { 
          resolve(data[0]);
        };
      });
    });
  }

  static existNickName(nickName) {
    return new Promise((resolve, reject) => {
      console.log(nickName);
      const query = "SELECT * FROM users WHERE nick_name = ?;";
      db.query(query, [nickName], (err, data) => {
        if (err) { 
          console.log(err);
          reject(`${err}`);
      }
        else { 
          console.log(data);
          resolve(data);
        };
      });
    });
  }

  static getFollower(userId) {
    return new Promise((resolve, reject) => {
      const query = "select * from friend where from_user = ?";;
      db.query(query, [userId], (err, data) => {
        if (err) { 
          reject(`${err}`);
      }
        else { 
          resolve(data);
        };
      });
    });
  }

  static getFollowee(userId) {
    return new Promise((resolve, reject) => {
      const query = "select * from friend where to_user = ?";;
      db.query(query, [userId], (err, data) => {
        if (err) { 
          reject(`${err}`);
      }
        else { 
          resolve(data);
        };
      });
    });
  }

  static getFollowCount(userId) {
    return new Promise((resolve, reject) => {
      const query = `
      SELECT count(*) as follower_count,
      (SELECT count(*) from friend where to_user = ?) as followee_count 
      FROM friend 
      WHERE from_user = ?;`;
      db.query(query, [userId,userId], (err, data) => {
        if (err) { 
          reject(`${err}`);
      }
        else { 
          resolve(data[0]);
        };
      });
    });
  }

  //*************************************************  POST  ***************************************************//
  static async save(userInfo) {
    return new Promise((resolve, reject) => {
      const query = "INSERT INTO users(id, mobile_number, nick_name,name,role_id,sex,birth) VALUES(?, ?, ?, ?, 0,?,?);";
      db.query(query, [userInfo.id, userInfo.mobile_number, userInfo.nick_name, userInfo.name,userInfo.sex,userInfo.birth], (err) => {
        if (err) {
          console.log(`${err}`);
          reject(`${err}`);
        }
        else resolve({ success: true });
      });
    });
  }

  static async isFollowed(userInfo){
    return new Promise((resolve,reject)=>{
      const query = "select * from friend where to_user = ? and from_user = ?";
      db.query(query,[userInfo.to_user,userInfo.from_user],(err,data)=>{
        if(err){
          console.log(err);
          reject(`${err}`);
        }else{
          resolve(data[0]);
        }
      })
    })
  }

  static async postFollower(userInfo) {
    return new Promise((resolve, reject) => {
      const query = "insert into friend(to_user,from_user) value(?,?);";
      db.query(query, [userInfo.to_user,userInfo.from_user], (err) => {
        if (err) {
          console.log(`${err}`);
          reject(`${err}`);
        }
        else resolve({ success: true });
      });
    });
  }

  //*************************************************  DELETE  ***************************************************//
  static async deleteFollower(userInfo) {
    return new Promise((resolve, reject) => {
      const query = "delete from friend where to_user = ? AND from_user = ?;";
      db.query(query, [userInfo.to_user,userInfo.from_user], (err) => {
        if (err) {
          console.log(`${err}`);
          reject(`${err}`);
        }
        else resolve({ success: true });
      });
    });
  }
}

  

module.exports = UserStorage;
