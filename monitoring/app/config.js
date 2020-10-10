require('dotenv').config();

module.exports = {

  logs: {
    apiVersion: process.env.LOGS_API_VERSION,
    region: process.env.LOGS_REGION,
    group: process.env.LOGS_GROUP,
    stream: process.env.LOGS_STREAM
  }
}
