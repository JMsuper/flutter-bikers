"use strict"

const FeedStorage = require("./FeedStorage");

class Feed{
    constructor(body){
        this.body = body;
    }

    static async getFeedAll(){
        try{
            const data = await FeedStorage.getFeedAll();
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    static async getFeedLatest(feedId,userId,limit){
        try{
            const data = await FeedStorage.getFeedLatestWithImage(feedId,userId,limit);
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    static async getFollowerFeed(feedId,userId,limit){
        try{
            const data = await FeedStorage.getFollowerFeed(feedId,userId,limit);
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    static async getFeedCount(userId){
        try{
            const data = await FeedStorage.getFeedCount(userId);
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    async textPost(){
        const contents = this.body;
        try{
            const response = await FeedStorage.saveFeed(contents);
            return response;
        } catch(err){
            return {success: false, err};
        }
    }

    async imagePost(){
        const contents = this.body;
        try{
            const response = await FeedStorage.saveImageFeed(contents);
            return response;
        } catch(err){
            return {success: false, err};
        }
    }
    async like(){
        try{
            const response = await FeedStorage.like(this.body.user_id,this.body.feed_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async unlike(){
        try{
            const response = await FeedStorage.unlike(this.body.user_id,this.body.feed_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async deleteFeed(){
        try{
	    const response = await FeedStorage.deleteFeed(this.body.feed_id);
	    return response;
	}catch(err){
		console.log(err);
	    return {success:false,err};
	} 
    }
}

module.exports = Feed;
