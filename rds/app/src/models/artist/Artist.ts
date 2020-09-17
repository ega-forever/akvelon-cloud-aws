import { BeforeInsert, BeforeUpdate, Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Song } from '../song/Song';
import { OneToMany } from 'typeorm/index';
import { Field, ObjectType } from 'type-graphql';

@Entity()
@ObjectType()
export class Artist {

  @Field()
  @PrimaryGeneratedColumn()
  public id: number;

  @Field()
  @Column()
  public name: string;

  @Field(type => [Song])
  @OneToMany(type => Song, song => song.artist, { cascade: true, nullable: true })
  public songs: Song[];

  @Field()
  @Column({ type: 'bigint' })
  public createdAt: number;

  @Column({ type: 'bigint' })
  public updatedAt: number;

  @BeforeInsert()
  public setInitialData() {
    this.createdAt = Date.now();
    this.updatedAt = Date.now();
  }

  @BeforeUpdate()
  public setUpdatedDate() {
    this.updatedAt = Date.now();
  }

}
