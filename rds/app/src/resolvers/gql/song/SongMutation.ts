import { Arg, Mutation, Resolver } from 'type-graphql';
import { Repository } from 'typeorm';
import { InjectRepository } from 'typeorm-typedi-extensions';
import { Artist } from '../../../models/artist/Artist';
import { Song } from '../../../models/song/Song';

@Resolver()
export default class SongMutation {

  @InjectRepository(Artist)
  private readonly artistRepository: Repository<Artist>;

  @InjectRepository(Song)
  private readonly songRepository: Repository<Song>;

  @Mutation(returnType => Song)
  public async songAdd(
    @Arg('name') name: string,
    @Arg('releaseDate') releaseDate: number,
    @Arg('artistId') artistId: number
  ): Promise<Song> {

    const artist: Artist = await this.artistRepository.findOne({ id: artistId });

    if (!artist) {
      throw new Error('artist not found');
    }

    const song: Song = this.songRepository.create({
      name,
      releaseDate,
      artist
    });

    await this.songRepository.save(song);
    return song;
  }

  @Mutation(returnType => Boolean)
  public async songRemove(
    @Arg('id') id: number
  ): Promise<boolean> {
    await this.songRepository.delete({ id });
    return true;
  }

}
