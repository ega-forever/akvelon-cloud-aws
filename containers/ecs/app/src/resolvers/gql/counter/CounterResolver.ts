import { Query, Resolver } from 'type-graphql';
import { Repository } from 'typeorm';
import { InjectRepository } from 'typeorm-typedi-extensions';
import { Counter } from '../../../models/counter/Counter';

@Resolver()
export default class CounterResolver {

  @InjectRepository(Counter)
  private counterRepository: Repository<Counter>;

  @Query(returns => Number)
  public async get(): Promise<number> {
    const counter: Counter = await this.counterRepository.findOne({});
    return counter ? counter.count : 0;
  }

}
