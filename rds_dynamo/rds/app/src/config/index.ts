import * as dotenv from 'dotenv';

dotenv.config();

export default {
  rest: {
    port: process.env.REST_PORT ? parseInt(process.env.REST_PORT, 10) : 3001
  },
  logLevel: process.env.LOG_LEVEL ? parseInt(process.env.LOG_LEVEL, 10) : 50,
  db: {
    type: process.env.DB_TYPE || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 5432,
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DB || 'music',
    logging: process.env.DB_LOGGING ? !!parseInt(process.env.DB_LOGGING, 10) : false,
    synchronize: process.env.DB_SYNC ? !!parseInt(process.env.DB_SYNC, 10) : true
  },
  gql: {
    introspection: process.env.GQL_INTROSPECTION ? !!parseInt(process.env.GQL_INTROSPECTION, 10) : false,
    playground: process.env.GQL_PLAYGROUND ? !!parseInt(process.env.GQL_PLAYGROUND, 10) : false
  }
};
