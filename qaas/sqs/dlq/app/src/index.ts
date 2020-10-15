import * as SQS from 'aws-sdk/clients/sqs';
import * as CloudWatchLogs from 'aws-sdk/clients/cloudwatchlogs';
import config from './config';

const sendLog = async (cloudWatchLogs: CloudWatchLogs, message) => {

  const description = await cloudWatchLogs.describeLogStreams({
    logGroupName: config.logs.group,
    logStreamNamePrefix: config.logs.stream
  }).promise();


  const params = {
    logEvents: [
      {
        message,
        timestamp: Date.now()
      }
    ],
    logGroupName: config.logs.group,
    logStreamName: config.logs.stream,
    sequenceToken: description.logStreams[0].uploadSequenceToken
  };

  await cloudWatchLogs.putLogEvents(params).promise();
}

const init = async () => {

  const sqs = new SQS({
    apiVersion: config.sqs.apiVersion,
    region: config.sqs.region
  });

  const cloudWatchLogs = new CloudWatchLogs({ apiVersion: config.logs.apiVersion, region: config.logs.region });

  // todo send message to source queue

  await sqs.sendMessage({
    MessageBody: JSON.stringify({ time: Date.now() }),
    QueueUrl: config.sqs.sourceQueue
  }).promise();

  while (1) {
    const dataSource = await sqs.receiveMessage({ QueueUrl: config.sqs.sourceQueue }).promise();
    const dataDLQ = await sqs.receiveMessage({ QueueUrl: config.sqs.DLQQueue }).promise();

    if (dataSource.Messages)
      for (const message of dataSource.Messages) {
        await sendLog(cloudWatchLogs, `source message: ${ message.Body }`);
      }

    if (!dataDLQ.Messages || !dataDLQ.Messages.length) {
      continue;
    }

    for (const message of dataDLQ.Messages) {
      await sendLog(cloudWatchLogs, `dlq message: ${ message.Body }`);
      await sqs.deleteMessage({
        QueueUrl: config.sqs.DLQQueue,
        ReceiptHandle: message.ReceiptHandle
      }).promise();
    }
  }


};

module.exports = init().catch(e => console.log(e));
