import { ApolloServer } from 'apollo-server-express';
import * as bodyParser from 'body-parser';
import * as bunyan from 'bunyan';
import * as express from 'express';
import * as cors from 'express-cors';
import 'reflect-metadata';
import { Container } from 'typedi';
import * as TypeORM from 'typeorm';
import * as projectConfig from '../package.json';
import config from './config';
import { DEFAULT } from './constants/connections';
import { DI } from './constants/DI';
import IContext from './interfaces/IContext';
import logMiddleware from './middleware/logger';
import { entities } from './models';
import { createSchema } from './resolvers/gql';
import http = require('http');

const logger = bunyan.createLogger({ name: 'core.rest' });

TypeORM.useContainer(Container);

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

  const options: TypeORM.ConnectionOptions = {
    entities,
    name: DEFAULT,
    ...config.db as any
  };

  await TypeORM.createConnection(options);
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
