"use strict";

const express = require("express");
const router = express.Router();

const ctrl = require("./feed.ctrl");

router.get("/all",ctrl.output.getFeedAll);
router.get("/latest",ctrl.output.getFeedLatestWithImage);
router.get("/follower",ctrl.output.getFollowerFeed);
router.get("/count",ctrl.output.getFeedCount);

router.post("/text", ctrl.process.text);
router.post("/image",ctrl.process.image);

router.put("/liked",ctrl.process.like);
router.put("/unliked",ctrl.process.unlike);

router.delete("/",ctrl.process.delete);

module.exports = router;
