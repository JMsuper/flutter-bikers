"use strict"

const db = require("../../config/db");

class FeedStorage{

    //*************************************************  GET  ***************************************************//
    static async getFeedAll(){
        return new Promise((resolve,reject)=>{
            db.query("SELECT * FROM feed",(err,data)=>{
                if(err) reject(`${err}`);
                else resolve(data);
            })
        })
    }


    // 이미지 테이블과 피드 테이블을 조인하던 쿼리와 피드 테이블을 SELECT하던 쿼리를 합쳐서 하나의 쿼리로 만들었다.
    static async getFeedLatest(feed_id,user_id,limit){
        if(!feed_id){
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT
                *, CASE WHEN friend.to_user is null THEN 0 ELSE 1 END as isfollower
               FROM 
               (
               SELECT f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,f.nick_name,f.image_url,
               CASE WHEN l.feed_id is null THEN 0 ELSE 1 END as isliked
               FROM (select f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,users.nick_name,users.image_url from feed as f join users on f.writer_id = users.id) as f 
               LEFT JOIN (SELECT * FROM liked_feed WHERE user_id = ?) AS l
               ON f.id = l.feed_id
               ORDER BY f.id DESC
               LIMIT ?
               ) as feed
               LEFT JOIN 
               (
               select from_user,to_user from friend where from_user = ?
               ) as friend
               ON feed.writer_id = friend.to_user ORDER BY id DESC;
                `
                db.query(query,[user_id,parseInt(limit),user_id],(err,data)=>{
                    if(err) {reject(`${err}`);console.log(err);}
                    else {
                        resolve(data);}
                });
            });
        }else{
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT
                    *, CASE WHEN friend.to_user is null THEN 0 ELSE 1 END as isfollower
                FROM 
                (
                SELECT f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,f.nick_name,f.image_url,
                CASE WHEN l.feed_id is null THEN 0 ELSE 1 END as isliked
                FROM (select f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,users.nick_name,users.image_url from feed as f join users on f.writer_id = users.id) as f 
                LEFT JOIN (SELECT * FROM liked_feed WHERE user_id = ?) AS l
                ON f.id = l.feed_id
                WHERE f.id < ?
                ORDER BY f.id DESC
                LIMIT ?
                ) as feed
                LEFT JOIN 
                (
                select from_user,to_user from friend where from_user = ?
                ) as friend
                ON feed.writer_id = friend.to_user ORDER BY id DESC;
                `
                db.query(query,[user_id,parseInt(feed_id),parseInt(limit),user_id],(err,data)=>{
                    if(err) {reject(`${err}`);console.log(err);}
                    else {
                        resolve(data);
                    }
                })
            });
        }
    }

    static async getFollowerFeedLatest(feed_id,user_id,limit){
        if(!feed_id){
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,f.nick_name,f.image_url,
                CASE WHEN l.feed_id is null THEN 0 ELSE 1 END as isliked
                FROM 
                    (select f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,users.nick_name,users.image_url from feed as f 
                    join 
                        (select users.id,users.nick_name,users.image_url 
                        from users 
                        join 
                        (select * from friend where from_user = ?) as f on users.id = f.to_user) as users
                    on f.writer_id = users.id) as f 
                LEFT JOIN (SELECT * FROM liked_feed WHERE user_id = ?) AS l
                ON f.id = l.feed_id
                ORDER BY f.id DESC
                LIMIT ?;
                `
                db.query(query,[user_id,user_id,parseInt(limit)],(err,data)=>{
                    if(err) {reject(`${err}`);console.log(err);}
                    else {
                        resolve(data);}
                });
            });
        }else{
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,f.nick_name,f.image_url,
                CASE WHEN l.feed_id is null THEN 0 ELSE 1 END as isliked
                FROM 
                    (SELECT f.id, f.writer_id,f.contents,f.like_count,f.created_date,f.has_image,f.comment_count,users.nick_name,users.image_url from feed as f 
                    JOIN 
                        (SELECT users.id,users.nick_name,users.image_url 
                        FROM users 
                        JOIN 
                        (select * from friend where from_user = ?) as f on users.id = f.to_user) as users
                    ON f.writer_id = users.id 
                    WHERE f.id < ?) as f 
                LEFT JOIN (SELECT * FROM liked_feed WHERE user_id = ?) AS l
                ON f.id = l.feed_id
                ORDER BY f.id DESC
                LIMIT ?;
                `
                db.query(query,[user_id,parseInt(feed_id),user_id,parseInt(limit)],(err,data)=>{
                    if(err) {reject(`${err}`);console.log(err);}
                    else {
                        resolve(data);
                    }
                })
            });
        }
    }

    static async getFeedLatestWithImage(feed_id,user_id,limit){
        const data = await this.getFeedLatest(feed_id,user_id,limit);
        var returnVal;
        await this.joinFeedAndImage(feed_id,limit)
        .then((feedAndImage)=>{
            const imageUrlJson = this.groupBy(feedAndImage,"id");
            returnVal = this.addListToJson(imageUrlJson, data);
        });
        return returnVal;
    }

    static async getFollowerFeed(feed_id,user_id,limit){
        const data = await this.getFollowerFeedLatest(feed_id,user_id,limit);
        var returnVal;
        await this.joinFeedAndImageWithFollower(feed_id,user_id,limit)
        .then((feedAndImage)=>{
            const imageUrlJson = this.groupBy(feedAndImage,"id");
            returnVal = this.addListToJson(imageUrlJson, data);
        });
        return returnVal;
    }

    static async joinFeedAndImage(feed_id,limit) {
        if(!feed_id){
            return new Promise((resolve, reject) => {
                const query = `
                SELECT feed.id, feed_image.image_url, feed_image.sequence 
                FROM (SELECT * FROM feed ORDER BY feed.id DESC limit ?) as feed 
                JOIN feed_image 
                ON feed.id = feed_image.feed_id
                ORDER BY id,sequence;
                                `;
                db.query(query, [parseInt(limit)],(err, data) => {
                    if (err) reject(err);
                    else resolve(data);
                })
            });
        }else{
            return new Promise((resolve, reject) => {
                const query = `
                SELECT feed.id, feed_image.image_url, feed_image.sequence 
                FROM (SELECT * FROM feed WHERE feed.id < ? ORDER BY feed.id DESC limit ?) as feed 
                JOIN feed_image 
                ON feed.id = feed_image.feed_id
                ORDER BY id,sequence;
                                `;
                db.query(query, [parseInt(feed_id),parseInt(limit)],(err, data) => {
                    if (err) reject(err);
                    else resolve(data);
                })
            });
        }
    }

    // feed테이블과 feed_image테이블을 조인한다.
    static async joinFeedAndImageWithFollower(feed_id,user_id,limit) {
        if(!feed_id){
            return new Promise((resolve, reject) => {
                const query = `
                SELECT feed.id, feed_image.image_url, feed_image.sequence 
                FROM 
                (select feed.id from feed 
                    join (select * from friend where from_user = ?) as f 
                    on feed.writer_id = f.to_user order by feed.id desc limit ?) as feed 
                JOIN feed_image 
                ON feed.id = feed_image.feed_id
                ORDER BY id,sequence;
                                `;
                db.query(query, [user_id,parseInt(limit)],(err, data) => {
                    if (err) {console.log(err);reject(err);}
                    else resolve(data);
                })
            });
        }else{
            return new Promise((resolve, reject) => {
                const query = `
                SELECT feed.id, feed_image.image_url, feed_image.sequence 
                FROM 
                (select feed.id from feed 
                    join (select * from friend where from_user = ?) as f 
                    on feed.writer_id = f.to_user where feed.id < ? order by feed.id desc limit ?) as feed 
                JOIN feed_image 
                ON feed.id = feed_image.feed_id
                ORDER BY id,sequence;
                                `;
                db.query(query, [user_id,parseInt(feed_id),parseInt(limit)],(err, data) => {
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
            if(list[i].has_image != 1) continue;
            for(var key in imageUrlJson){
                if(key == list[i].id){
                    list[i]["imageUrlList"] = imageUrlJson[key];
                    delete imageUrlJson.key;
                }
            }
        }
        return list;
    }

    static async getFeedCount(userId){
        return new Promise((resolve,reject)=>{
            db.query(`SELECT count(*) as feed_count FROM feed where writer_id = ?`,[userId],(err,data)=>{
                if(err) reject(`${err}`);
                else resolve(data[0]);
            })
        })
    }


    //*************************************************  POST  ***************************************************//
    static async saveFeed(contents){
        return new Promise((resolve, reject)=>{
            const query = "INSERT INTO feed(writer_id,contents,has_image) values(?,?,?)";
            db.query(query,[contents.writer_id,contents.contents,contents.has_image],(err)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else {
                    resolve({success:true});
                };
            });
        }
        );
    }

    static async getMaxFeedId(writer_id){
        return new Promise((resolve,reject)=>{
            const getFeedIdQuery = "SELECT MAX(id) FROM feed WHERE writer_id = ?";
            db.query(getFeedIdQuery,[writer_id],(err,data)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else {
                    resolve(data[0]["MAX(id)"]);
                };
            });
        })
    }
    static async saveFeedImageUrl(feedId,imageUrls){
        return new Promise((resolve,reject)=>{
            var query = "INSERT INTO feed_image(feed_id,image_url,sequence) values";
            for(let i = 0; i < imageUrls.length;i++){
                const data = imageUrls[i];
                query += "("+ feedId +",\""+ data.image_url +"\","+ data.sequence+")";
                if(i < imageUrls.length-1) query += ",";
                else query += ";";
            };
            db.query(query,(err)=>{
                if(err) reject(`${err}`);
                else resolve({success:true});
            });
        })
    }

    static async saveImageFeed(contents){
        const imageUrls = JSON.parse(contents.imageUrls);
        return await this.saveFeed(contents)
        .then(()=>{
            return this.getMaxFeedId(contents.writer_id);
        }).then((feedId)=>{
            return this.saveFeedImageUrl(feedId,imageUrls);
        }).catch((err)=>{
            return `${err}`;
        })
    }


        //*************************************************  UPDATE  ***************************************************//
        static async like(user_id,feed_id){
            return new Promise((resolve,reject)=>{
                const query = `INSERT INTO liked_feed(user_id,feed_id) values(?,?);
                UPDATE feed SET like_count = like_count + 1 WHERE id = ?; `
                db.query(query,[user_id,feed_id,feed_id],(err,data)=>{
                    if(err){
                        reject(`${err}`);
                    }else{
                        resolve(data);
                    }
                });
            });
        }
    
        static async unlike(user_id,feed_id){
            return new Promise((resolve,reject)=>{
                const query = `DELETE FROM liked_feed WHERE user_id = ? AND feed_id = ?;
                UPDATE feed SET like_count = like_count - 1 WHERE id = ?; `
                db.query(query,[user_id,feed_id,feed_id],(err,data)=>{
                    if(err){
                        reject(`${err}`);
                    }else{
                        resolve(data);
                    }
                });
            });
        }
	//*********************************************** DELETE ******************************************************//
	static async deleteFeed(feed_id){
	    // query 실행이 synchronos하게 되어야 한다.
	    return new Promise((resolve, reject)=>{
	        const query = `DELETE FROM feed_image WHERE feed_id=?;DELETE FROM feed WHERE id=?`;
		    console.log(feed_id);
		db.query(query,[feed_id,feed_id],(err,data)=>{
		    if(err){
		        reject(`${err}`);
		    }else{
		        resolve(data);
		    }
		});
	    });
	}
}

module.exports = FeedStorage;
