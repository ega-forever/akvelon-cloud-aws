const express = require('express'),
  bodyParser = require('body-parser'),
  route = require('.'),
  app = express();

app.use(bodyParser.json({ type: 'application/*+json' }))

app.all('/', async (req, res)=>{
  const result = await route.helloWorld({});
  return res.status(result.statusCode).send(result.body);
});

app.listen(8080, ()=>{
  console.log('server started on port 8080');
});