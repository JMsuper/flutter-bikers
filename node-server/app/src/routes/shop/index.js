"use strict"

const express = require("express");
const router = express.Router();

const ctrl = require("./shop.ctrl");

router.get("/all",ctrl.output.getShopFeedAll);
router.get("/latest",ctrl.output.getShopLatestWithImage);

router.post("/",ctrl.process.post);

router.put("/liked",ctrl.process.like);
router.put("/unliked",ctrl.process.unlike);


module.exports = router;