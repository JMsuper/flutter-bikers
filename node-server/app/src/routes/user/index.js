"use strict";

const express = require("express");
const router = express.Router();

const ctrl = require("./user.ctrl");

router.get("/info",ctrl.output.getUserInfo);
router.get("/nickName",ctrl.output.existNickName);

router.get("/follower",ctrl.output.getFollower);
router.get("/followee",ctrl.output.getFollowee);
router.get("/followCount",ctrl.output.getFollowCount);

router.post("/new", ctrl.process.new);
router.post("/follower",ctrl.process.postFollower);

router.delete("/follower",ctrl.process.deleteFollower);

module.exports = router;