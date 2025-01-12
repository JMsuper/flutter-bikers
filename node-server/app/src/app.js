"use strict";

// 모듈
const express = require("express");
const app = express();
const socketIO = require("socket.io");
const http = require("http");
const server = http.createServer(app);
const io = socketIO(server);
const util = require("util");
const ChatStorage = require("./models/chat/ChatStorage");

// 라우팅
const feed = require("./routes/feed");
const feedComment = require("./routes/feedComment")
const user = require("./routes/user");
const shop = require("./routes/shop");
const tour = require("./routes/tour");
const chat = require("./routes/chat")


// 앱 세팅
app.use(express.static(`${__dirname}/src/public`));
app.use(express.json());
app.use(express.urlencoded({extended:true}));

app.use("/feed",feed);
app.use("/feedComment",feedComment);
app.use("/user",user);
app.use("/shop",shop);
app.use("/tour",tour);
app.use("/chat",chat);

io.on('connection',(socket)=>{
    util.log('a user conneted',socket.id);

    socket.on("join", function(roomId, fn){
        socket.join(roomId, function(){
	    util.log("Join", roomId, Object.keys(socket.rooms));
	});
	socket.broadcast.to(roomId).emit("seen",{});
    });
    
    socket.on("leave", function(roomId,fn){
		if(roomId != null){
			socket.leave(roomId);
			console.log("socket leave call!");
		}
    });

    // socket.on("joinChange", function(roomFrom,roomTo){
    //     socket.leave(roomFrom);
	// socket.join(roomTo);
    // });

    socket.on("message",(data, fn)=>{
		socket.broadcast.to(data.room).emit("message",
			{msg: data.msg,room:data.room,writerId:data.writerId,memCount:data.memCount});
		fn({status:"success"});
		ChatStorage.postMessage(data.room,data.writerId,data.msg,1);
    });

	socket.on("seen",(data,fn)=>{
		console.log("seen");
		socket.broadcast.to(data.room).emit("seen",{});
		ChatStorage.msgChangeToSeen(data.room,data.userId);
	});

    socket.on('disconnect',()=>{
        util.log('user disconnected', socket.id);
    });
});

server.listen(3000, function(){
    console.log("서버 가동");
});

