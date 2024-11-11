var express = require("express");
var router = express.Router();
var Web3 = require("web3");
// var group_contract = require("../contract/group.js");

/* GET home page. */
router.get("/", function (req, res, next) {
  res.render("mainPage", { title: "hello" });
});

module.exports = router;
