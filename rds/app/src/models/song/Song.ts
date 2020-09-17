import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Artist } from '../artist/Artist';
import { ManyToOne } from 'typeorm/index';
import { Field, ObjectType } from 'type-graphql';

@Entity()
@ObjectType()
export class Song {

  @Field()
  @PrimaryGeneratedColumn()
  public id: number;

  @ManyToOne(type => Artist, artist => artist.songs)
  public artist: Artist;

  @Field()
  @Column()
  public name: string;

  @Field()
  @Column({ type: 'bigint' })
  public releaseDate: number;

}
