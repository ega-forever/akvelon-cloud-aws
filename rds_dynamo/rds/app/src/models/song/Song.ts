import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Artist } from '../artist/Artist';
import { Index, ManyToOne } from 'typeorm';
import { Field, ObjectType } from 'type-graphql';
import { GenreType } from '../../constants/GenreType';

@Entity()
@ObjectType()
@Index(['releaseDate', 'genreType'])
export class Song {

  @Field()
  @PrimaryGeneratedColumn()
  public id: number;

  @Index()
  @ManyToOne(type => Artist, artist => artist.songs)
  public artist: Artist;

  @Field()
  @Column()
  public name: string;

  @Field()
  @Column()
  public genreType: GenreType;

  @Field()
  @Column({ type: 'bigint' })
  public releaseDate: number;

}
