import { Arg, Mutation, Resolver } from 'type-graphql';
import { Repository } from 'typeorm';
import { InjectRepository } from 'typeorm-typedi-extensions';
import { Artist } from '../../../models/artist/Artist';

@Resolver()
export default class ArtistMutation {

  @InjectRepository(Artist)
  private readonly artistRepository: Repository<Artist>;

  @Mutation(returnType => Artist)
  public async artistAdd(
    @Arg('name') name: string
  ): Promise<Artist> {
    const artist: Artist = this.artistRepository.create({ name });
    await this.artistRepository.save(artist);
    return artist;
  }

  @Mutation(returnType => Artist)
  public async artistRemove(
    @Arg('id') id: number
  ): Promise<boolean> {
    await this.artistRepository.delete({ id });
    return true;
  }

}
