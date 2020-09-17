import { Arg, Query, Resolver } from 'type-graphql';
import { Repository } from 'typeorm';
import { InjectRepository } from 'typeorm-typedi-extensions';
import { Artist } from '../../../models/artist/Artist';

@Resolver()
export default class ArtistResolver {

  @InjectRepository(Artist)
  private artistRepository: Repository<Artist>;

  @Query(returns => [Artist])
  public async artistList(
    @Arg('skip', type => Number, { nullable: true, defaultValue: 0 }) skip: number,
    @Arg('limit', type => Number, { nullable: true, defaultValue: 10 }) limit: number
  ): Promise<Artist[]> {
    return this.artistRepository.find({
      take: limit,
      skip
    });
  }

}
