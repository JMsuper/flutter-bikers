"use strict"

const User = require("../../models/user/User");
const { sendResponse } = require("../../utils/response.util");

const output = {
    getUserInfo: async (req, res) => {
        try {
            const { id } = req.query;
            const data = await User.getUserInfo(id);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    existNickName: async (req, res) => {
        try {
            const { nickName } = req.query;
            const data = await User.existNickName(nickName);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    getFollower: async (req, res) => {
        try {
            const { user_id: userId } = req.query;
            const data = await User.getFollower(userId);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    getFollowee: async (req, res) => {
        try {
            const { user_id: userId } = req.query;
            const data = await User.getFollowee(userId);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    getFollowCount: async (req, res) => {
        try {
            const { user_id: userId } = req.query;
            const data = await User.getFollowCount(userId);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    }
};

const process = {
    new: async (req, res) => {
        try {
            const user = new User(req.body);
            const response = await user.register();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    postFollower: async (req, res) => {
        try {
            const user = new User(req.body);
            const response = await user.postFollower();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    deleteFollower: async (req, res) => {
        try {
            const user = new User(req.body);
            const response = await user.deleteFollower();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    }
};

module.exports = { output, process };