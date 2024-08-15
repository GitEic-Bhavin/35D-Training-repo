const express = require('express');
const app = express();
app.get('/', (req, res) => {
  res.send('Hello World from node! Node is running on localhost:5000 by nginx')
});
app.listen(5000, () => console.log('Server is up and running on 5000'));
