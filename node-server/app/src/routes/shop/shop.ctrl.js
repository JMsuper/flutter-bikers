"use strict"

const Shop = require("../../models/shop/Shop");
const { sendResponse } = require("../../utils/response.util");

const output = {
    getShopFeedAll: async (req, res) => {
        try {
            const data = await Shop.getShopFeedAll();
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    getShopLatestWithImage: async (req, res) => {
        try {
            const { goods_id: goodsId, user_id: userId, limit } = req.query;
            const data = await Shop.getShopLatest(goodsId, userId, limit);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    }
};

const process = {
    post: async (req, res) => {
        try {
            const shop = new Shop(req.body);
            const response = await shop.Post();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    like: async (req, res) => {
        try {
            const shop = new Shop(req.body);
            const response = await shop.like();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    unlike: async (req, res) => {
        try {
            const shop = new Shop(req.body);
            const response = await shop.unlike();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    }
};

module.exports = { output, process };