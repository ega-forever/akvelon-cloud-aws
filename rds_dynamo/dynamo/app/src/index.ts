import { ApolloServer } from 'apollo-server-express';
import * as bodyParser from 'body-parser';
import * as bunyan from 'bunyan';
import * as express from 'express';
import * as cors from 'express-cors';
import 'reflect-metadata';
import { Container } from 'typedi';
import * as projectConfig from '../package.json';
import config from './config';
import { DI } from './constants/DI';
import IContext from './interfaces/IContext';
import logMiddleware from './middleware/logger';
import { createSchema } from './resolvers/gql';
import http = require('http');
import * as AWS from 'aws-sdk';
import { entities } from './models/dynamo';

const logger = bunyan.createLogger({ name: 'core.rest' });

const bootstrap = async () => {
  const app = express();
  app.use(bodyParser.json({ limit: '3mb' }));
  app.use(bodyParser.urlencoded({
    extended: true
  }));
  app.use(cors());
  app.use(logMiddleware);

  app.get('/info', (req, res) => {
    res.send({ uptime: process.uptime(), version: projectConfig.version });
  });

  app.get('/', (req, res) => res.send({ ok: 1 }));

  const dynamodb = new AWS.DynamoDB({
    endpoint: config.dynamodb.endpoint,
    region: config.dynamodb.region
  });

  const tables = await dynamodb.listTables({}).promise();

  for (const schema of entities) {
    if (tables.TableNames.includes(schema.TableName)) {
      continue;
    }

    const table = await dynamodb.createTable(schema).promise();
    logger.info(`table created ${ table.TableDescription.TableArn }`);
  }

  Container.set({ id: DI.dynamodb, factory: () => dynamodb });


  const schema: any = await createSchema();

  Container.set({ id: DI.logger, factory: () => logger });

  const server = new ApolloServer({
    schema,
    introspection: config.gql.introspection,
    playground: config.gql.playground ? {
      endpoint: '/playground'
    } : false,
    context: ({ req }): IContext => {
      return {
        req
      };
    }
  });

  server.applyMiddleware({ app, path: '/' });
  const httpServer = http.createServer(app);
  server.installSubscriptionHandlers(httpServer);

  httpServer.listen(config.rest.port, () => {
    logger.info(`Server ready on port ${ config.rest.port }`);
  });
  httpServer.setTimeout(4 * 60 * 1000);
};

bootstrap().catch((err) => {
  logger.error(err);
  process.exit(0);
});
