require('dotenv').config();

export default {
  sqs: {
    firstQueue: process.env.SQS_FIRST_QUEUE,
    secondQueue: process.env.SQS_SECOND_QUEUE,
    region: process.env.SQS_REGION,
    apiVersion: process.env.SQS_API_VERSION
  },
  sns: {
    topicArn: process.env.SNS_TOPIC_ARN,
    region: process.env.SNS_REGION,
    apiVersion: process.env.SNS_API_VERSION
  },
  logs: {
    apiVersion: process.env.LOGS_API_VERSION,
    region: process.env.LOGS_REGION,
    group: process.env.LOGS_GROUP,
    stream: process.env.LOGS_STREAM
  }
};
