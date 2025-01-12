"use strict"

const Chat = require("../../models/chat/Chat");
const { sendResponse } = require("../../utils/response.util");

const output = {
	getChatRoomAll: async (req, res) => {
		try {
			const { user_id: userId } = req.query;
			const data = await Chat.getChatRoomAll(userId);
			return sendResponse(res, data);
		} catch (error) {
			return sendResponse(res, { err: error.message }, 400);
		}
	},
	getChatMessage: async(req, res)=>{
	    const roomId = req.query.room_id;
	    const userId = req.query.user_id;
	    const data = await Chat.getChatMessage(roomId,userId);
	    return res.send(data);
	},
	getChatInShop: async (req, res) => {
		try {
			const { goods_id: goodsId, user_id: userId } = req.query;
			const data = await Chat.getChatInShop(goodsId, userId);
			return sendResponse(res, data);
		} catch (error) {
			return sendResponse(res, { err: error.message }, 400);
		}
	}
};

const process = {
	postMessage: async (req, res) => {
		try {
			const chat = new Chat(req.body);
			const response = await chat.postMessage();
			return sendResponse(res, response, response.err ? 409 : 201);
		} catch (error) {
			return sendResponse(res, { err: error.message }, 400);
		}
	},
	createChatRoom: async (req, res) => {
		try {
			const chat = new Chat(req.body);
			const response = await chat.createChatRoom();
			return sendResponse(res, response);
		} catch (error) {
			return sendResponse(res, { err: error.message }, 400);
		}
	}
};

module.exports = { output, process };
