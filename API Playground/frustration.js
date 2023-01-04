const fetch = require("node-fetch");

let query5 = 'mutation ($myItemName: String!, $columnVals: JSON!) { create_item (board_id:2060969269, item_name:$myItemName, column_values:$columnVals) { id } }';
let vars = {
  "myItemName" : "node to the rescue i guess!",
  "columnVals" : JSON.stringify({
    "status" : {"label" : "Stuck"}
  })
};

fetch ("https://api.monday.com/v2", {
  method: 'post',
  headers: {
    'Content-Type': 'application/json',
    'Authorization' : 'eyJhbGciOiJIUzI1NiJ9.eyJ0aWQiOjIwOTg5NDI0MCwidWlkIjoyNTQ1Mzg5MSwiaWFkIjoiMjAyMi0xMi0xNlQxNToxMzowNS4wMDBaIiwicGVyIjoibWU6d3JpdGUiLCJhY3RpZCI6OTgwODUzMiwicmduIjoidXNlMSJ9.sa2-Fr22Y7gWZnZi4TCgXzwt1Luj254QrK51cAHnbtk'
  },
  body: JSON.stringify({
    'query' : query5,
    'variables' : JSON.stringify(vars)
  })
})
  .then(res => res.json())
  .then(res => console.log(JSON.stringify(res, null, 2)));