const axios = require('axios');

require('dotenv').config();

let data = process.env.EMAINT,
    buff = new Buffer(data),
    encoded = buff.toString('base64');

const headers = {
    'Content-Type': 'application/json',
    'Authorization': encoded
};