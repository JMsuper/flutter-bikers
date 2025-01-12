"use strict"

const Feed = require("../../models/feed/Feed");

const createResponse = (method, path, response) => {
    const url = {
        method,
        path,
        status: response.err ? 409 : 201
    };
    return url;
};

const output = {
    getFeedAll: async (req, res)=>{
        const data = await Feed.getFeedAll();
        return res.send(data);
    },
    getFeedLatestWithImage: async (req, res)=>{
        const {feed_id: feedId, user_id: userId, limit} = req.query;
        const data = await Feed.getFeedLatest(feedId, userId, limit);
        return res.send(data);
    },
    getFollowerFeed: async (req, res)=>{
        const {feed_id: feedId, user_id: userId, limit} = req.query;
        const data = await Feed.getFollowerFeed(feedId, userId, limit);
        return res.send(data);
    },
    getFeedCount: async (req, res)=>{
        const {user_id: userId} = req.query;
        const data = await Feed.getFeedCount(userId);
        return res.send(data);
    },
}

const process = {
    text: async (req, res)=>{
        const feed = new Feed(req.body);
        const response = await feed.textPost();
        const url = createResponse("POST", "/feed/text", response);
        return res.status(url.status).json(response);
    },
    image: async (req, res)=>{
        const feed = new Feed(req.body);
        const response = await feed.imagePost();
        const url = createResponse("POST", "/feed/image", response);
        return res.status(url.status).json(response);
    },
    like: async(req,res)=>{
        const feed = new Feed(req.body);
        const response = await feed.like();
        const url = createResponse("PUT", "/feed/liked", response);
        return res.status(url.status).json(response);
    },
    unlike: async(req,res)=>{
        const feed = new Feed(req.body);
        const response = await feed.unlike();
        const url = createResponse("PUT", "/feed/unliked", response);
        return res.status(url.status).json(response);
    },
    delete: async(req,res)=>{
        console.log(req.body);
        const feed = new Feed(req.body);
        const response = await feed.deleteFeed();
        const url = createResponse("DELETE", "/feed/", response);
        return res.status(url.status).json(response);
    }
}

module.exports = {output,process};
