"use strict"

const db = require("../../config/db");

class ChatStorage{

	//*************************************************  GET  ***************************************************//

    static async getChatRoom(userId){
        return new Promise((resolve,reject)=>{
	    const query = 
		`
		select 
		chat.room_id,chat.contents,chat.created_date,chat.goods_id,users.nick_name,users.image_url
		from (
			select * from
			(select m.message_id,m.room_id,m.writer_id,m.contents, m.created_date,r.goods_id,r.seller_id from chat_message as m
				join (
					select * from chat_room 
					where seller_id= ? or buyer_id=?) as r
				on m.room_id = r.room_id) as r
			where (room_id,message_id)
			in(
				select room_id, max(message_id) from chat_message group by room_id
			) ) as chat
		join users on chat.seller_id = users.id
		order by chat.created_date desc;
		`;
	    db.query(query,[userId,userId],(err,data)=>{
	        if(err){
		   console.log(err);
		   reject({success:false,err});
		}else{
		    resolve(data);
		}
	    });
	});
    }

    static async getNotViewedMsgCount(userId){
        return new Promise((resolve, reject)=>{
	    const query =	
		`
		select m.room_id,count(message_id) as not_viewed from chat_message as m 
			join (select * from chat_room where seller_id = ? or buyer_id = ?) as r 
		where  m.room_id = r.room_id and writer_id <> ? and isviewed = 1 group by m.room_id;
		`;
	    db.query(query,[userId,userId,userId],(err,data)=>{
	        if(err){
		    console.log(err);
		    reject({success:false,err});
		}else{
		    resolve(data);
		}
	    });
	});
    }

    static async getChatRoomAll(userId){   
        let chatRoom = await this.getChatRoom(userId);
	let notViewList = await this.getNotViewedMsgCount(userId);
	for(let i = 0; i < chatRoom.length; i++){
	    for(let j = 0; j < notViewList.length; j++){
		if(notViewList[j].room_id == chatRoom[i].room_id){
		    chatRoom[i].not_viewed = notViewList[j].not_viewed;
		}
	    }
	}
	return chatRoom;
    }

    static async getChatMessage(roomId,userId){
		await this.msgChangeToSeen(roomId,userId);
        return new Promise((resolve,reject)=>{
	    const query =
		`
		SELECT * FROM chat_message where room_id = ? order by created_date;
		`;
	    db.query(query,[roomId,userId,roomId],(err,data)=>{
	        if(err){
		    console.log(err);
		    reject({success:false,err});
		}else{
		     resolve(data);
		}
	    });
	});
    }

    static async checkRoomExist(goodsId,userId){
        return new Promise((resolve, reject)=>{
			const query = 
			`
			SELECT * FROM chat_room  WHERE goods_id = ? AND buyer_id = ? LIMIT 1;
			`
			db.query(query,[goodsId,userId],(err,data)=>{
				if(err){
					reject({sucess:false,err});
				}else{
					resolve(data);
				}
			});
		});
    }

    static async getChatInShop(goodsId,userId){
        const data = await this.checkRoomExist(goodsId,userId);
		console.log(data);
		if(data.length !== 0){
			console.log(data[0]);
			console.log(data[0].room_id);
			const chatMessages = await this.getChatMessage(data[0].room_id,userId);
			return chatMessages
		}else{
			return [];
		}
    }

	//*************************************************  POST  ***************************************************//

    static async postMessage(roomId,userId,contents,isviewed){
	console.log(roomId,userId,contents);
    	return new Promise((resolve,reject)=>{
	    const query =
	        `
	        INSERT INTO chat_message(room_id,writer_id,contents,isviewed) values(?,?,?,?);	
	        `;
	    db.query(query,[roomId,userId,contents,isviewed],(err,data)=>{
	        if(err){
		    console.log(err);
		    reject({success:false,err});
		}else{
		    resolve({success:true});
		}
	    })
	})
    }

    static createChatRoom(goodsId,sellerId,buyerId){
    	console.log(goodsId,sellerId,buyerId);
		return new Promise((resolve,reject)=>{
			const query = 
			`
			INSERT INTO chat_room(goods_id,seller_id,buyer_id) values(?,?,?);
			SELECT room_id FROM chat_room WHERE goods_id = ? AND buyer_id = ?;
			`;
			db.query(query,[goodsId,sellerId,buyerId,goodsId,buyerId],(err,data)=>{
				if(err){
				console.log(err);
				reject({success:false,err});
			}else{
				resolve(data[1]);
			}
			});
		});
    }

	//*************************************************  UPDATE  ***************************************************//

	static async msgChangeToSeen(roomId,userId){
        return new Promise((resolve, reject)=>{
			const query = 
			`
			UPDATE chat_message SET isviewed = 0 where room_id = ? AND writer_id <> ?;
			`
			db.query(query,[roomId,userId],(err,data)=>{
				if(err){
					reject({sucess:false,err});
				}else{
					resolve();
				}
			});
		});
    }

	//*************************************************  DELETE  ***************************************************//
}

module.exports = ChatStorage;

