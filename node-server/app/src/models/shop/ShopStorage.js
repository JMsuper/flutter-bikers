"use strict"

const db = require("../../config/db");

class ShopStorage{

    //*************************************************  GET  ***************************************************//
    static async getShopFeedAll(){
        return new Promise((resolve,reject)=>{
            db.query("SELECT * FROM goods_post",(err,data)=>{
                if(err) reject(`${err}`);
                else resolve(data);
            })
        })
    }

    // 이미지 테이블과 피드 테이블을 조인하던 쿼리와 피드 테이블을 SELECT하던 쿼리를 합쳐서 하나의 쿼리로 만들었다.
    static async getShopLatest(goods_id,user_id,limit){
        if(!goods_id){
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT s.goods_id, s.writer_id,s.title,s.contents,s.price,s.like_count,s.created_date,
                s.view_count,s.category_id,s.region_id,s.goods_state_id,
                CASE WHEN l.goods_id is null THEN 0 ELSE 1 END as isliked
                FROM goods_post as s 
                LEFT JOIN (SELECT * FROM liked_goods WHERE user_id = ?) AS l
                ON s.goods_id = l.goods_id
                ORDER BY s.goods_id DESC
                LIMIT ?;
                `
                db.query(query,[user_id,parseInt(limit)],(err,data)=>{
                    if(err) {reject(`${err}`);console.log(err);}
                    else {console.log(data);resolve(data);}
                });
            });
        }else{
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT s.goods_id, s.writer_id,s.title,s.contents,s.price,s.like_count,s.created_date,
                s.view_count,s.category_id,s.region_id,s.goods_state_id,
                CASE WHEN l.goods_id is null THEN 0 ELSE 1 END as isliked
                FROM goods_post as s 
                LEFT JOIN (SELECT * FROM liked_goods WHERE user_id = ?) AS l
                ON s.goods_id = l.goods_id
                WHERE s.goods_id < ?
                ORDER BY s.goods_id DESC
                LIMIT ?;
                `
                db.query(query,[user_id,parseInt(goods_id),parseInt(limit)],(err,data)=>{
                    if(err) {reject(`${err}`);console.log(err);}
                    else {console.log(data);resolve(data);}
                })
            });
        }
    }


    static async getShopLatestWithImage(goods_id,user_id,limit){
        const data = await this.getShopLatest(goods_id,user_id,limit);
        var returnVal;
        await this.joinShopAndImage(goods_id,limit)
        .then((goodsAndImage)=>{
            const imageUrlJson = this.groupBy(goodsAndImage,"goods_id");
            console.log(imageUrlJson);
            returnVal = this.addListToJson(imageUrlJson, data);
        });
        return returnVal;
    }

    static async joinShopAndImage(goods_id,limit) {
        if(!goods_id){
            return new Promise((resolve, reject) => {
                const query = `
                SELECT goods.goods_id, gi.image_url, gi.sequence 
                FROM (SELECT * FROM goods_post ORDER BY goods_id DESC limit ?) as goods 
                JOIN goods_image as gi
                ON goods.goods_id = gi.goods_id
                ORDER BY goods_id,sequence;
                                `;
                db.query(query, [parseInt(limit)],(err, data) => {
                    if (err) reject(err);
                    else resolve(data);
                })
            });
        }else{
            return new Promise((resolve, reject) => {
                const query = `
                SELECT goods.goods_id, gi.image_url, gi.sequence 
                FROM (SELECT * FROM goods_post WHERE goods_id < ? ORDER BY goods_id DESC limit ?) as goods 
                JOIN goods_image as gi
                ON goods.goods_id = gi.goods_id
                ORDER BY goods_id,sequence;
                                `;
                db.query(query, [parseInt(goods_id),parseInt(limit)],(err, data) => {
                    if (err) reject(err);
                    else resolve(data);
                })
            });
        }
    }

    // data배열의 요소들을 key에 따라 그룹화하여 json형태로 재구성한다.
    static groupBy(data, key) {
        return data.reduce(function (accumulator, currentValue) {
            var group = currentValue[key];
    
            if (accumulator[group] === undefined) {
                accumulator[group] = []
            }
    
            accumulator[group].push(currentValue.image_url)
            return accumulator
        }, {})
    }
    
    // 이미지url배열을 담은 json을 list에 해당하는 id에 맞춰 추가한다.
    static addListToJson(imageUrlJson, list){
        for(let i = 0; i < list.length; i++){
            for(var key in imageUrlJson){
                if(key == list[i].goods_id){
                    list[i]["imageUrlList"] = imageUrlJson[key];
                    delete imageUrlJson.key;
                }
            }
        }
        return list;
    }


    //*************************************************  POST  ***************************************************//
    static async saveGoodsPost(contents){
        return new Promise((resolve, reject)=>{
            const query = "INSERT INTO goods_post(writer_id,title,contents,price,category_id,region_id) values(?,?,?,?,?,?)";
            db.query(query,[contents.writer_id,contents.title,contents.contents,contents.price,contents.category_id,contents.region_id],(err)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else {
                    console.log("saveGoodsPost success");
                    resolve({success:true});
                };
            });
        }
        );
    }

    static async getMaxGoodsId(writer_id){
        console.log("getMaxGoodsId function start!");
        return new Promise((resolve,reject)=>{
            console.log("getMaxGoodsId function Promise start!");
            const getShopIdQuery = "SELECT MAX(goods_id) FROM goods_post WHERE writer_id = ?;";
            db.query(getShopIdQuery,[writer_id],(err,data)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else {
                    resolve(data[0]["MAX(goods_id)"]);
                };
            });
        })
    }
    static async saveGoodsImageUrl(goodsId,imageUrls){
        console.log("saveGoodsImageUrl function start!");
        return new Promise((resolve,reject)=>{
            var query = "INSERT INTO goods_image(goods_id,image_url,sequence) values";
            for(let i = 0; i < imageUrls.length;i++){
                const data = imageUrls[i];
                query += "("+ goodsId +",\""+ data.image_url +"\","+ data.sequence+")";
                if(i < imageUrls.length-1) query += ",";
                else query += ";";
            };
            db.query(query,(err)=>{
                if(err) reject(`${err}`);
                else resolve({success:true});
            });
        })
    }

    static async saveShopFeed(contents){
        console.log(contents);
        const imageUrls = JSON.parse(contents.imageUrls);
        return await this.saveGoodsPost(contents)
        .then(()=>{
            return this.getMaxGoodsId(contents.writer_id);
        }).then((goodsId)=>{
            return this.saveGoodsImageUrl(goodsId,imageUrls);
        }).catch((err)=>{
            return `${err}`;
        })
    }

    //*************************************************  UPDATE  ***************************************************//
    static async like(user_id,goods_id){
        return new Promise((resolve,reject)=>{
            console.log("user_id:",user_id," goods_id",goods_id);
            const query = `INSERT INTO liked_goods(user_id,goods_id) values(?,?);
            UPDATE goods_post SET like_count = like_count + 1 WHERE goods_id = ?; `
            db.query(query,[user_id,goods_id,goods_id],(err,data)=>{
                if(err){
                    reject(`${err}`);
                }else{
                    resolve(data);
                }
            })
        });
    }

    static async unlike(user_id,goods_id){
        return new Promise((resolve,reject)=>{
            const query = `DELETE FROM liked_goods WHERE user_id = ? AND goods_id = ?;
            UPDATE goods_post SET like_count = like_count - 1 WHERE goods_id = ?; `
            db.query(query,[user_id,goods_id,goods_id],(err,data)=>{
                if(err){
                    reject(`${err}`);
                }else{
                    resolve(data);
                }
            })
        });
    }
}

module.exports = ShopStorage;