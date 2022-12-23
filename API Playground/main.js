const axios = require('axios'),
  express = require('express');
require('dotenv').config();

const app = express(),
  port = 3000;
 
app.use(express.json());
 
const config = { headers: { 
  'Authorization': process.env.MONDAY_API_TOKEN, 
  'Content-Type': 'application/json'
} },
body = {
  'query':
};

app.post('/monday', (req, res) => {
  axios.post('https://api.monday.com/v2', body, config)
  .then(

  );
});
app.listen(port, () =>
  console.log(`Example app listening at http://localhost:${port}`)
); 