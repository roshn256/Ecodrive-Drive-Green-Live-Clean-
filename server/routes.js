const express = require("express");
const router = express.Router();
const handlers = require('./handlers');

router.post("/api/login", handlers.login);
router.post("/api/signup", handlers.signup);
router.post("/api/calculate", handlers.calculate);
router.post("/api/redeem", handlers.redeem);

module.exports = router;