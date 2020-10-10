import bunyan = require('bunyan');
import config from './config';
import express from 'express';
import bodyParser from 'body-parser';
import Lock from './Lock';
import Promise from 'bluebird';

const logger = bunyan.createLogger({ name: 'mokka.logger', level: 30 });

const init = async () => {
  const index = parseInt(process.env.INDEX, 10);

  const lock = new Lock(config.client, '/test/lock');
  await lock.start();


  const rpc = express();
  rpc.use(bodyParser.json());

  rpc.post('/send', async (req, res) => {

    await lock.lock();
    await Promise.delay(10000);
    await lock.unLock();

    res.send({ status: 1 });
  });

  rpc.listen(config.nodes[index].rpc, () => {
    logger.info(`rpc started on port: ${ config.nodes[index].rpc }`)
  });

};


module.exports = init();