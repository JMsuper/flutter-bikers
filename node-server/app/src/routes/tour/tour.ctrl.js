"use strict"

const Tour = require("../../models/tour/Tour");
const { sendResponse } = require("../../utils/response.util");

const output = {
    getTourAll: async (req, res) => {
        try {
            const data = await Tour.getTourAll();
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    getTourLatest: async (req, res) => {
        try {
            const { tour_id: tourId, user_id: userId, limit } = req.query;
            const data = await Tour.getTourLatest(tourId, userId, limit);
            return sendResponse(res, data);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    }
};

const process = {
    post: async (req, res) => {
        try {
            const tour = new Tour(req.body);
            const response = await tour.Post();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    delete: async (req, res) => {
        try {
            const tour = new Tour(req.body);
            const response = await tour.delete();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    like: async (req, res) => {
        try {
            const tour = new Tour(req.body);
            const response = await tour.like();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    },

    unlike: async (req, res) => {
        try {
            const tour = new Tour(req.body);
            const response = await tour.unlike();
            return sendResponse(res, response, response.err ? 409 : 201);
        } catch (error) {
            return sendResponse(res, { err: error.message }, 400);
        }
    }
};

module.exports = { output, process };