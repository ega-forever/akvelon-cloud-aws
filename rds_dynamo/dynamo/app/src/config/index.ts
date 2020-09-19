import * as dotenv from 'dotenv';

dotenv.config();

export default {
  rest: {
    port: process.env.REST_PORT ? parseInt(process.env.REST_PORT, 10) : 3001
  },
  logLevel: process.env.LOG_LEVEL ? parseInt(process.env.LOG_LEVEL, 10) : 50,
  dynamodb: {
    endpoint: process.env.DYNAMODB_ENDPOINT,
    region: process.env.DYNAMODB_REGION
  },
  gql: {
    introspection: process.env.GQL_INTROSPECTION ? !!parseInt(process.env.GQL_INTROSPECTION, 10) : false,
    playground: process.env.GQL_PLAYGROUND ? !!parseInt(process.env.GQL_PLAYGROUND, 10) : false
  }
};
