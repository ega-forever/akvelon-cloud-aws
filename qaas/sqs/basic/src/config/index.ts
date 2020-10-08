require('dotenv').config();

export default {
  sqs: {
    queue: process.env.SQS_QUEUE,
    region: process.env.SQS_REGION,
    apiVersion: process.env.SQS_API_VERSION
  }
};
