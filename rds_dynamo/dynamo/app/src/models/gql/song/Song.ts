import { Field, ObjectType } from 'type-graphql';

@ObjectType()
export class Song {

  @Field()
  public name: string;

  @Field()
  public genreType: number;

  @Field()
  public id: string;

  @Field()
  public releaseDate: number;

  @Field()
  public artistId: string;

}
