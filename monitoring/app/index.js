const express = require('express'),
  AWSXRay = require('aws-xray-sdk'),
  AWS = require('aws-sdk'),
  config = require('./config'),
  app = express();

const cloudWatchLogs = new AWS.CloudWatchLogs({apiVersion: config.logs.apiVersion, region: config.logs.region});

app.use(AWSXRay.express.openSegment('MyApp'));

app.get('/', (req, res) => {
  res.send({ok: 1});
});

app.get('/log', async (req, res) => {

  const description = await cloudWatchLogs.describeLogStreams({
    logGroupName: config.logs.group,
    logStreamNamePrefix: config.logs.stream
  }).promise();


  const params = {
    logEvents: [
      {
        message: JSON.stringify({ip: req.ip}),
        timestamp: Date.now()
      }
    ],
    logGroupName: config.logs.group,
    logStreamName: config.logs.stream,
    sequenceToken: description.logStreams[0].uploadSequenceToken
  };

  await cloudWatchLogs.putLogEvents(params).promise();
  res.send({ok: 1});
});

app.use(AWSXRay.express.closeSegment());

app.listen(80, () => {
  console.log('app started on 80 port');
});
