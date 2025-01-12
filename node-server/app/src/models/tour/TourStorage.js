"use strict"

const db = require("../../config/db");

class TourStorage{

    //*************************************************  GET  ***************************************************//
    static async getTourAll(){
        return new Promise((resolve,reject)=>{
            db.query("SELECT * FROM tour_post ORDER BY tour_id DESC",(err,data)=>{
                if(err) reject(`${err}`);
                else resolve(data);
            })
        })
    }

    static async getTourLatest(tour_id,user_id,limit){
        if(!tour_id){
            return new Promise((resolve,reject)=>{
                const query = `
                SELECT t.tour_id,t.writer_id,t.title,t.contents,t.region_lat,t.region_lng,t.start_date,t.member_num,t.like_count,t.created_date,t.view_count,
                CASE WHEN l.tour_id is null THEN 0 ELSE 1 END as isliked
                FROM tour_post as t 
                LEFT JOIN (SELECT * FROM liked_tour WHERE user_id = ?) AS l
                ON t.tour_id = l.tour_id
                ORDER BY t.tour_id DESC
                LIMIT ?;
                `
                db.query(query,[user_id,parseInt(limit)],(err,data)=>{
                    if(err) reject(`${err}`);
                    else resolve(data);
                });
            })
        }
        else{
            return new Promise((resolve,reject)=>{
                console.log(user_id + " "+parseInt(tour_id) + " " +parseInt(limit));
                const query = `
                SELECT t.tour_id,t.writer_id,t.title,t.contents,t.region_lat,t.region_lng,t.start_date,t.member_num,t.like_count,t.created_date,t.view_count,
                CASE WHEN l.tour_id is null THEN 0 ELSE 1 END as isliked
                FROM tour_post as t 
                LEFT JOIN (SELECT * FROM liked_tour WHERE user_id = ?) AS l
                ON t.tour_id = l.tour_id
                WHERE t.tour_id < ?
                ORDER BY t.tour_id DESC
                LIMIT ?;
                `
                db.query(query,[user_id,parseInt(tour_id),parseInt(limit)],(err,data)=>{
                    if(err) {
                        console.log(err);
                        reject(`${err}`);
                    }
                    else {console.log(data);resolve(data);}
                });
            })
        }
    }


    //*************************************************  POST  ***************************************************//
    static async post(data){
        return new Promise((resolve, reject)=>{
            const query = `INSERT INTO 
                            tour_post(writer_id,title,contents,region_lat,region_lng,start_date,member_num)
                            values(?,?,?,?,?,?,?)`;
            db.query(query,
                [data.writer_id,data.title,data.contents,data.region_lat,data.region_lng,data.start_date,data.member_num],
                (err)=>{
                if(err) {
                    console.log(err);
                    reject(`${err}`);
                }
                else {
                    console.log("saveTourPost success");
                    resolve({success:true});
                };
            });
        }
        );
    }

    //*************************************************  DELETE  ***************************************************//
    static async delete(tour_id){
        return new Promise((resolve,reject)=>{
            const query = `
            DELETE FROM liked_tour WHERE tour_id = ?;
            DELETE FROM tour_post WHERE tour_id = ?;
            `;
            db.query(query,[tour_id,tour_id],(err)=>{
                if(err){
                    console.log(err);
                    reject(`${err}`);
                }else{
                    resolve({success:true});
                }
            })
        });
    }

    static async checkWriter(tour_id){
        return new Promise((resolve,reject)=>{
            const query = `SELECT writer_id FROM tour_post WHERE tour_id = ?;`
            db.query(query,[tour_id],(err,data)=>{
                if(err){
                    console.log(err);
                    reject(`${err}`);
                }else{
                    resolve(data);
                }
            });
        });
    }

    //*************************************************  UPDATE  ***************************************************//
    static async like(user_id,tour_id){
        return new Promise((resolve,reject)=>{
            console.log("user_id:",user_id," tour_id",tour_id);
            const query = `INSERT INTO liked_tour(user_id,tour_id) values(?,?);
            UPDATE tour_post SET like_count = like_count + 1 WHERE tour_id = ?; `
            db.query(query,[user_id,tour_id,tour_id],(err,data)=>{
                if(err){
                    reject(`${err}`);
                }else{
                    resolve(data);
                }
            })
        });
    }

    static async unlike(user_id,tour_id){
        return new Promise((resolve,reject)=>{
            const query = `DELETE FROM liked_tour WHERE user_id = ? AND tour_id = ?;
            UPDATE tour_post SET like_count = like_count - 1 WHERE tour_id = ?; `
            db.query(query,[user_id,tour_id,tour_id],(err,data)=>{
                if(err){
                    reject(`${err}`);
                }else{
                    resolve(data);
                }
            })
        });
    }

}

module.exports = TourStorage;