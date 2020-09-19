import { Arg, Query, Resolver } from 'type-graphql';
import { Repository } from 'typeorm';
import { InjectRepository } from 'typeorm-typedi-extensions';
import { Song } from '../../../models/song/Song';
import { GenreType } from '../../../constants/GenreType';

@Resolver()
export default class SongResolver {

  @InjectRepository(Song)
  private songRepository: Repository<Song>;

  @Query(returns => [Song])
  public async songsListByArtist(
    @Arg('artistId', type => Number, { nullable: true }) artistId: number,
    @Arg('skip', type => Number, { nullable: true, defaultValue: 0 }) skip: number,
    @Arg('limit', type => Number, { nullable: true, defaultValue: 10 }) limit: number
  ): Promise<Song[]> {
    return this.songRepository.createQueryBuilder('s')
      .where('s.artist = :artist', { artist: artistId })
      .skip(skip)
      .take(limit)
      .getMany();
  }


  @Query(returns => [Song])
  public async songsListByGenre(
    @Arg('genreType', type => Number, { nullable: true }) genreType: GenreType,
    @Arg('skip', type => Number, { nullable: true, defaultValue: 0 }) skip: number,
    @Arg('limit', type => Number, { nullable: true, defaultValue: 10 }) limit: number
  ): Promise<Song[]> {
    return this.songRepository.createQueryBuilder('s')
      .where('s.genreType = :genreType', { genreType })
      .orderBy('releaseDate', 'DESC')
      .skip(skip)
      .take(limit)
      .getMany();
  }

}
