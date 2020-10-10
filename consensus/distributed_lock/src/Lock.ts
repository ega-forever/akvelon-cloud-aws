import zookeeper from 'node-zookeeper-client';
import { promisify } from 'util';

export default class Lock {

  private zpath: string;
  private electionZPath: string;
  private client: zookeeper;
  private clientId: string;

  constructor(uri: string, zpath: string) {
    this.zpath = zpath;
    this.electionZPath = zpath + '/-';
    this.client = zookeeper.createClient(uri);
  }

  public async start() {
    this.client.connect();
    await new Promise(res => this.client.once('connected', res));

    await promisify(this.client.mkdirp.bind(this.client))(this.zpath);
  }

  public async lock() {
    await this.await();
    this.clientId = await promisify(this.client.create.bind(this.client))(this.electionZPath, zookeeper.CreateMode.EPHEMERAL_SEQUENTIAL);
  }

  public async await() {
    let locked = true;

    while (locked) {
      await new Promise(async res => {

        const newChildren = await promisify(this.client.getChildren.bind(this.client))(this.zpath, res);
        if (!newChildren.length) {
          locked = false;
          res();
        }
      });
    }
  }

  public async unLock() {
    await promisify(this.client.remove.bind(this.client))(this.clientId);
  }

}