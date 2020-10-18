import { Mutation, Resolver } from 'type-graphql';
import { Repository } from 'typeorm';
import { InjectRepository } from 'typeorm-typedi-extensions';
import { Counter } from '../../../models/counter/Counter';

@Resolver()
export default class CounterMutation {

  @InjectRepository(Counter)
  private readonly counterRepository: Repository<Counter>;

  @Mutation(returnType => Number)
  public async increment(): Promise<number> {
    const counter: Counter = await this.counterRepository.findOne();

    if(!counter){
      const item = this.counterRepository.create();
      await this.counterRepository.save(item);
      return 1;
    }

    await this.counterRepository.increment({}, 'count', 1);
    return counter.count + 1;
  }

}
