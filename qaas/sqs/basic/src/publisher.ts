import * as SQS from 'aws-sdk/clients/sqs';
import config from './config';

const init = async () => {

  const sqs = new SQS({
    apiVersion: config.sqs.apiVersion,
    region: config.sqs.region
  });


  while (1) {
    await sqs.sendMessage({
      MessageBody: JSON.stringify({ time: Date.now() }),
      QueueUrl: config.sqs.queue
    }).promise();

    await new Promise(res => setTimeout(res, 5000));
  }


};

module.exports = init().catch(e => console.log(e));
