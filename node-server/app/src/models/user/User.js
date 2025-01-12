"use strict";

const UserStorage = require("./UserStorage");

class User {
  constructor(body) {
    this.body = body;
  }

  static async getUserInfo(id){
      try{
        const userInfo = await UserStorage.getUserInfo(id);
        return userInfo;
      }catch(err){
        return {success: false, err};
      }
  }
 
  static async existNickName(nickName){
    try{
      const isExist = await UserStorage.existNickName(nickName);
      if(isExist.length != 0){
        return {isNotExist: false};
      }else{
        return {isNotExist: true};
      }
    }catch(err){
      console.log(err);
      return {success: false, err};
    }
  }

  static async getFollower(userId){
    try{
      const data = await UserStorage.getFollower(userId);
      return data;
    }catch(err){
      return {success: false, err};
     }
  }

  static async getFollowee(userId){
    try{
      const data = await UserStorage.getFollowee(userId);
      return data;
    }catch(err){
      return {success: false, err};
     }
  }

  static async getFollowCount(userId){
    try{
      const data = await UserStorage.getFollowCount(userId);
      return data;
    }catch(err){
      return {success: false, err};
     }
  }

  async register() {
    const client = this.body;
    try {
      const response = await UserStorage.save(client);
      return response;
    } catch (err) {
      console.log(err);
      return { success: false, err };
    }
  }

  async postFollower() {
    const client = this.body;
    try {
      const data = await UserStorage.isFollowed(client);
      if(data == undefined){
        const response = await UserStorage.postFollower(client);
        return response;
      }else{
        return {success: false, isExist: true};
      }
    } catch (err) {
      console.log(err);
      return { success: false, err };
    }
  }

  async deleteFollower() {
    const client = this.body;
    try {
      const response = await UserStorage.deleteFollower(client);
      return response;
    } catch (err) {
      console.log(err);
      return { success: false, err };
    }
  }

}

module.exports = User;