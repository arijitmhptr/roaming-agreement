const express = require('express');
const router = express.Router();
const { queryAgreements } = require('../controller/agreement');

router.route('/')
        .post(queryAgreements);

module.exports = router;