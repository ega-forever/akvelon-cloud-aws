require('dotenv').config();

export default {
  sqs: {
    sourceQueue: process.env.SQS_SOURCE_QUEUE,
    DLQQueue: process.env.SQS_DLQ_QUEUE,
    region: process.env.SQS_REGION,
    apiVersion: process.env.SQS_API_VERSION
  },
  logs: {
    apiVersion: process.env.LOGS_API_VERSION,
    region: process.env.LOGS_REGION,
    group: process.env.LOGS_GROUP,
    stream: process.env.LOGS_STREAM
  }
};
