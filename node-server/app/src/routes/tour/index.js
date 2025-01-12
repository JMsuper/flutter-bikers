"use strict"

const express = require("express");
const router = express.Router();

const ctrl = require("./tour.ctrl");

router.get("/all",ctrl.output.getTourAll);
router.get("/latest",ctrl.output.getTourLatest);

router.post("/",ctrl.process.post);

router.put("/liked",ctrl.process.like);
router.put("/unliked",ctrl.process.unlike);

router.delete("/",ctrl.process.delete);


module.exports = router;