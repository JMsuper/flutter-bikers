"use strict"

const FeedComment = require("../../models/feedComment/FeedComment");

const createResponse = (method, path, response) => {
    return {
        method,
        path,
        status: response.err ? 409 : 201
    };
};

const output = {
    getFeedComment: async (req, res)=>{
        const {feed_id: feedId, user_id: userId} = req.query;
        const data = await FeedComment.getFeedComment(feedId, userId);
        return res.send(data);
    },
    getFeedChildComment: async (req, res)=>{
        const {feed_comment_id: feedCommentId, user_id: userId} = req.query;
        const data = await FeedComment.getFeedChildComment(feedCommentId, userId);
        return res.send(data);
    }
}

const process = {
    comment: async (req, res)=>{
        const feedComment = new FeedComment(req.body);
        const response = await feedComment.postComment();
        const url = createResponse("POST", "/feedComment", response);
        return res.status(url.status).json(response);
    },
    childComment: async (req, res)=>{
        const feedComment = new FeedComment(req.body);
        const response = await feedComment.postChildComment();
        const url = createResponse("POST", "/feedComment/child", response);
        return res.status(url.status).json(response);
    },
    like: async(req,res)=>{
        const feedComment = new FeedComment(req.body);
        const response = await feedComment.like();
        const url = createResponse("PUT", "/feedComment/liked", response);
        return res.status(url.status).json(response);
    },
    unlike: async(req,res)=>{
        const feedComment = new FeedComment(req.body);
        const response = await feedComment.unlike();
        const url = createResponse("PUT", "/feedComment/unliked", response);
        return res.status(url.status).json(response);
    },
    childLike: async(req,res)=>{
        const feedComment = new FeedComment(req.body);
        const response = await feedComment.childLike();
        const url = createResponse("PUT", "/feedComment/child/liked", response);
        return res.status(url.status).json(response);
    },
    childUnlike: async(req,res)=>{
        const feedComment = new FeedComment(req.body);
        const response = await feedComment.childUnlike();
        const url = createResponse("PUT", "/feedComment/child/unliked", response);
        return res.status(url.status).json(response);
    }
}

module.exports = {output,process};