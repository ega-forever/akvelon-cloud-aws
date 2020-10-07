const config = require('./config'),
  SQSCtrl = require('./controllers/SQSCtrl');

const init = async () => {

  const sqsCtrl = new SQSCtrl(config.connection.queue, config.connection.region, config.apiVersion);

  sqsCtrl.subscribe();

  sqsCtrl.on('data', async data => {
    try {
      const parsed = JSON.parse(data.message);
      console.log(parsed);
    } catch (e) {
      await data.nack();
    }

    await data.ack();
  })


};

module.exports = init();
