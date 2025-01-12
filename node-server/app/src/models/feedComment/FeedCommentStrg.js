"use strict"

const db = require("../../config/db");

class FeedCommentStrg{

    //*************************************************  GET  ***************************************************//

    // static commentGroupBy(data, key) {
    //     return data.reduce(function (accumulator, currentValue) {
    //         var group = currentValue[key];
    
    //         if (accumulator[group] === undefined) {
    //             accumulator[group] = []
    //         }
    
    //         accumulator[group].push(currentValue)
    //         return accumulator
    //     }, {})
    // }

    static async getFeedComment(feedId,userId){
        return new Promise((resolve,reject)=>{
            const query = `
            SELECT  fc.id,fc.writer_id,fc.feed_id,fc.contents,fc.like_count,fc.comment_count,fc.created_date,
            fc.nick_name,fc.image_url,
            CASE WHEN l.feed_comment_id is null THEN 0 ELSE 1 END as isliked
            FROM 
            (SELECT
                fc.id,fc.writer_id,fc.feed_id,fc.contents,fc.like_count,fc.comment_count,fc.created_date,
                u.nick_name,u.image_url 
                FROM feed_comment as fc 
                JOIN users as u ON fc.writer_id = u.id 
                WHERE fc.feed_id = ?) as fc
            LEFT JOIN (SELECT * FROM liked_feed_comment WHERE user_id = ?) as l
            ON fc.id = l.feed_comment_id
            ORDER BY fc.id DESC;
            `;
            db.query(query,[feedId,userId],(err,data)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else {
                    resolve(data);
                };
            })
        })
    }

    static async getFeedChildComment(feedCommentId,userId){
        return new Promise((resolve,reject)=>{
            const query = `
            SELECT  fc.id,fc.writer_id,fc.feed_comment_id,fc.contents,fc.like_count,fc.created_date,
            fc.nick_name,fc.image_url,
            CASE WHEN l.feed_child_comment_id is null THEN 0 ELSE 1 END as isliked
            FROM 
            (SELECT
                fc.id,fc.writer_id,fc.feed_comment_id,fc.contents,fc.like_count,fc.created_date,
                u.nick_name,u.image_url 
                FROM feed_child_comment as fc 
                JOIN users as u ON fc.writer_id = u.id 
                WHERE fc.feed_comment_id = ?) as fc
            LEFT JOIN (SELECT * FROM liked_feed_child_comment WHERE user_id = ?) as l
            ON fc.id = l.feed_child_comment_id
            ORDER BY fc.id DESC;
            `;
            db.query(query,[feedCommentId,userId],(err,data)=>{
                if(err) {
                    reject(`${err}`);
                }
                else {
                    resolve(data);
                };
            })
        })
    }

    // static async getFeedComment(feedId){
    //     return new Promise((resolve,reject)=>{
    //         const query = `
    //         SELECT  fc.id,fc.writer_id,fc.feed_id,fc.contents,fc.step,fc.parent_id,fc.created_date,
    //         u.nick_name,u.image_url
    //         FROM feed_comment as fc
    //         JOIN users as u
    //         ON fc.writer_id = u.id
    //         WHERE fc.feed_id = ? 
    //         ORDER BY fc.id DESC;
    //         `;
    //         db.query(query,[feedId],(err,data)=>{
    //             if(err) {
    //                 reject(`${err}`);
    //             }
    //             else {
    //                 if(data.length == 0){
    //                     resolve(data);
    //                 }else{
    //                     const groupedJson = this.commentGroupBy(data,"step");
    //                     if(groupedJson["1"] !== undefined){
    //                         for(let i = 0; i < groupedJson["1"].length; i++){
    //                             for(let j = 0; j < groupedJson["0"].length; j++){
    //                                 if(groupedJson["0"][j].id == groupedJson["1"][i].parent_id){
    //                                     if(groupedJson["0"][j]["child"] === undefined){
    //                                         groupedJson["0"][j]["child"] = [];
    //                                     }
    //                                     groupedJson["0"][j]["child"].push(groupedJson["1"][i]);
    //                                 }
    //                             }
    //                         }
    //                     }
    //                     resolve(groupedJson["0"]);
    //                 }
    //             };
    //         })
    //     })
    // }

    //*************************************************  POST  ***************************************************//

    static async postComment(contents){
        return new Promise((resolve,reject)=>{
            const query = `
            INSERT INTO feed_comment(writer_id,feed_id,contents) 
            VALUES(?,?,?);
            UPDATE feed SET comment_count = comment_count + 1 WHERE id = ?;
            `
            db.query(query,[contents.writer_id,contents.feed_id,contents.contents,contents.feed_id],(err)=>{
                if(err) reject(`${err}`);
                else resolve({success:true});
            });
        });
    }
    static async postChildComment(contents){
        return new Promise((resolve,reject)=>{
            const query = `
            INSERT INTO feed_child_comment(writer_id,feed_comment_id,contents) 
            VALUES(?,?,?);
            UPDATE feed_comment SET comment_count = comment_count + 1 WHERE id = ?;
            `
            db.query(query,[contents.writer_id,contents.feed_comment_id,contents.contents,contents.feed_comment_id],(err)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else resolve({success:true});
            });
        });
    }

        //*************************************************  UPDATE  ***************************************************//
        static async like(user_id,feed_comment_id){
            return new Promise((resolve,reject)=>{
                const query = `INSERT INTO liked_feed_comment(user_id,feed_comment_id) values(?,?);
                UPDATE feed_comment SET like_count = like_count + 1 WHERE id = ?; `
                db.query(query,[user_id,feed_comment_id,feed_comment_id],(err,data)=>{
                    if(err){
                        reject(`${err}`);
                    }else{
                        resolve(data);
                    }
                })
            });
        }
    
        static async unlike(user_id,feed_comment_id){
            return new Promise((resolve,reject)=>{
                const query = `DELETE FROM liked_feed_comment WHERE user_id = ? AND feed_comment_id = ?;
                UPDATE feed_comment SET like_count = like_count - 1 WHERE id = ?; `
                db.query(query,[user_id,feed_comment_id,feed_comment_id],(err,data)=>{
                    if(err){
                        reject(`${err}`);
                    }else{
                        resolve(data);
                    }
                })
            });
        }

        static async childLike(user_id,feed_child_comment_id){
            return new Promise((resolve,reject)=>{
                const query = `INSERT INTO liked_feed_child_comment(user_id,feed_child_comment_id) values(?,?);
                UPDATE feed_child_comment SET like_count = like_count + 1 WHERE id = ?; `
                db.query(query,[user_id,feed_child_comment_id,feed_child_comment_id],(err,data)=>{
                    if(err){
                        console.log(err);
                        reject(`${err}`);
                    }else{
                        resolve(data);
                    }
                })
            });
        }
    
        static async childUnlike(user_id,feed_child_comment_id){
            return new Promise((resolve,reject)=>{
                const query = `DELETE FROM liked_feed_child_comment WHERE user_id = ? AND feed_child_comment_id = ?;
                UPDATE feed_child_comment SET like_count = like_count - 1 WHERE id = ?; `
                db.query(query,[user_id,feed_child_comment_id,feed_child_comment_id],(err,data)=>{
                    if(err){
                        reject(`${err}`);
                    }else{
                        resolve(data);
                    }
                })
            });
        }
}

module.exports = FeedCommentStrg;