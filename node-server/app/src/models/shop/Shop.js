"use strict"

const ShopStorage = require("./ShopStorage");

class Shop{
    constructor(body){
        this.body = body;
    }

    static async getShopFeedAll(){
        try{
            const data = await ShopStorage.getShopFeedAll();
            return data;
        }catch(err){
            return {success: false, err};
        }      
    }

    static async getShopLatest(goodsId,userId,limit){
        try{
            const data = await ShopStorage.getShopLatestWithImage(goodsId,userId,limit);
            return data;
        }catch(err){
            return {success: false, err};
        }
    }

    async Post(){
        try{
            const response = await ShopStorage.saveShopFeed(this.body);
            return response;
        }catch(err){
            console.log(err);
            return {success: false, err};
        }       
    }

    async like(){
        try{
            const response = await ShopStorage.like(this.body.user_id,this.body.goods_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async unlike(){
        try{
            const response = await ShopStorage.unlike(this.body.user_id,this.body.goods_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }
}

module.exports = Shop;