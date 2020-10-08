import * as SQS from 'aws-sdk/clients/sqs';
import config from './config';

const init = async () => {

  const sqs = new SQS({
    apiVersion: config.sqs.apiVersion,
    region: config.sqs.region
  });

  while (1) {
    const data = await sqs.receiveMessage({ QueueUrl: config.sqs.queue }).promise();

    if (!data.Messages || !data.Messages.length) {
      continue;
    }

    for (const message of data.Messages) {

      await sqs.deleteMessage({
        QueueUrl: config.sqs.queue,
        ReceiptHandle: message.ReceiptHandle
      }).promise();

      console.log(`received ${ message.Body }`);
    }
  }



};

module.exports = init().catch(e => console.log(e));
