"use strict"

const FeedCommentStrg = require("./FeedCommentStrg");

class Feed{
    constructor(body){
        this.body = body;
    }

    static async getFeedComment(feedId,userId){
        try{
            const data = await FeedCommentStrg.getFeedComment(feedId,userId);
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    static async getFeedChildComment(feedCommentId,userId){
        try{
            const data = await FeedCommentStrg.getFeedChildComment(feedCommentId,userId);
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    async postComment(){
        const contents = this.body;
        try{
            const response = await FeedCommentStrg.postComment(contents);
            return response;
        } catch(err){
            console.log(err);
            return {success: false, err};
        }
    }
    async postChildComment(){
        const contents = this.body;
        try{
            const response = await FeedCommentStrg.postChildComment(contents);
            return response;
        } catch(err){
            return {success: false, err};
        }
    }
    async like(){
        try{
            const response = await FeedCommentStrg.like(this.body.user_id,this.body.feed_comment_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async unlike(){
        try{
            const response = await FeedCommentStrg.unlike(this.body.user_id,this.body.feed_comment_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async childLike(){
        try{
            const response = await FeedCommentStrg.childLike(this.body.user_id,this.body.feed_child_comment_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async childUnlike(){
        try{
            const response = await FeedCommentStrg.childUnlike(this.body.user_id,this.body.feed_child_comment_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

}

module.exports = Feed;