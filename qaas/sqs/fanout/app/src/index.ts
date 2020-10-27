import * as SQS from 'aws-sdk/clients/sqs';
import * as CloudWatchLogs from 'aws-sdk/clients/cloudwatchlogs';
import * as SNS from 'aws-sdk/clients/sns';
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
  const sns = new SNS({ apiVersion: config.sns.apiVersion, region: config.sns.region });

  // todo send message to source queue

  await sns.publish({
    TopicArn: config.sns.topicArn,
    Message: JSON.stringify({ time: Date.now() })
  }).promise();

  console.log('!!!')

  while (1) {
    const dataFirst = await sqs.receiveMessage({ QueueUrl: config.sqs.firstQueue }).promise();
    const dataSecond = await sqs.receiveMessage({ QueueUrl: config.sqs.secondQueue }).promise();

    const items = [
      {
        messages: dataFirst.Messages,
        queue: config.sqs.firstQueue
      },
      {
        messages: dataSecond.Messages,
        queue: config.sqs.secondQueue
      }
    ]


    for (const item of items)
      if (item.messages)
        for (const message of item.messages) {
          console.log(`${item.queue} message: ${ message.Body }`)
          await sendLog(cloudWatchLogs, `${item.queue} message: ${ message.Body }`);
          await sqs.deleteMessage({
            QueueUrl: item.queue,
            ReceiptHandle: message.ReceiptHandle
          }).promise();
        }
  }


};

module.exports = init().catch(e => console.log(e));
