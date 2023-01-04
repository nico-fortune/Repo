'use strict'

const filePath = '',
    crypto = require('crypto');
let output = undefined;

module.exports = {
    log: (type, message) => {
        output = 
        `{
            "id": ${crypto.randomUUID()},
            "type": ${type},
            "timestamp":${Date.now()},
            "info": ${message}
        }`;
        console.log(output);
        return output;
    },
    larger: (a, b) => {
        if(a >= b && a > 0) return a;
        else if(b > a && b > 0) return b;
        else return null;
    }
};