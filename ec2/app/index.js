const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send({ok: 1});
});


app.get('/long', (req, res) => {
  setTimeout(() => {
    res.send({ok: 2});
  }, 5000);
});

const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 8080;

app.listen(port, () => {
  console.log(`app started on port ${port}`);
});
