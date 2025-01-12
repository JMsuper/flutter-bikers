"use strict"

const TourStorage = require("./TourStorage");

class Tour{
    constructor(body){
        this.body = body;
    }

    static async getTourAll(){
        try{
            const data = await TourStorage.getTourAll();
            return data;
        }catch(err){
            return {success: false, err};
        }      
    }

    static async getTourLatest(tourId,userId,limit){
        try{
            const data = await TourStorage.getTourLatest(tourId,userId,limit);
            return data;
        }catch(err){
            return {success: false, err};
        }  
    }
  

    async Post(){
        try{
            const response = await TourStorage.post(this.body);
            return response;
        }catch(err){
            console.log(err);
            return {success: false, err};
        }       
    }

    async delete(){
        try{
            const checkWriterResponse = await TourStorage.checkWriter(this.body.tour_id);
            var writerId;

            if(checkWriterResponse.length === 0){
                return{success:false,err:"tour_id not found"};
            }else{
                writerId = checkWriterResponse[0].writer_id;
                if(writerId != this.body.user_id){
                    return{success:false,err:"user_id and writer_id not matched"};
                }else{
                    const response = await TourStorage.delete(this.body.tour_id);
                    return response;
                }
            }
        }catch(err){
            console.log(err);
            return {success:false,err};
        }
    }

    async like(){
        try{
            const response = await TourStorage.like(this.body.user_id,this.body.tour_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }

    async unlike(){
        try{
            const response = await TourStorage.unlike(this.body.user_id,this.body.tour_id);
            return response;
        }catch(err){
            return {success:false,err};
        }
    }
}

module.exports = Tour;