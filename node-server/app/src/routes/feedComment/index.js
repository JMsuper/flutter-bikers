"use strict";

const express = require("express");
const router = express.Router();

const ctrl = require("./feedComment.ctrl");

router.get("/",ctrl.output.getFeedComment);
router.get("/child",ctrl.output.getFeedChildComment);

router.post("/",ctrl.process.comment);
router.post("/child",ctrl.process.childComment);

router.put("/liked",ctrl.process.like);
router.put("/unliked",ctrl.process.unlike);
router.put("/child/liked",ctrl.process.childLike);
router.put("/child/unliked",ctrl.process.childUnlike);

module.exports = router;