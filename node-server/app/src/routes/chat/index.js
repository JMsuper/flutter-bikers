"use strict";

const express = require("express");
const router = express.Router();

const ctrl = require("./chat.ctrl");

router.get("/room/",ctrl.output.getChatRoomAll);
router.get("/room/message",ctrl.output.getChatMessage);
router.get("/inShop",ctrl.output.getChatInShop);

router.post("/room/message",ctrl.process.postMessage);
router.post("/room",ctrl.process.createChatRoom);

module.exports = router;
