"use strict"

const ChatStorage = require("./ChatStorage");

class Chat{
    constructor(body){
        this.body = body;
	    console.log(body);
	    console.log(this.body);
    }

    static async getChatRoomAll(userId){
        try{
	    const data = await ChatStorage.getChatRoomAll(userId);
	    return data;
	}catch(err){
		console.log(err);
	    return err;
	}
    }

    static async getChatMessage(roomId,userId){
        try{
	    const data = await ChatStorage.getChatMessage(roomId,userId);
	    return data;
	}catch(err){
	    return err;
	}
    }

    static async getChatInShop(goodsId,userId){
        try{
	    const data = await ChatStorage.getChatInShop(goodsId,userId);
	    return data;
	}catch(err){
	    return err;
	}
    }

    async postMessage(){
    	try{
		console.log(this.body.room_id);
	    const data = await ChatStorage.postMessage(this.body.room_id,this.body.user_id,this.body.contents,this.body.isviewed);
	    console.log(data);
	    return data;
	}catch(err){
	    return err;
	}
    }

    async createChatRoom(){
        try{
	    const data = await ChatStorage.createChatRoom(this.body.goods_id,this.body.seller_id,this.body.buyer_id);
	    if(data.length !== 1){
	        return {success:"false"};
	    }
	    return data[0];
	}catch(err){
	    return err;
	}
    }
}

module.exports = Chat;
