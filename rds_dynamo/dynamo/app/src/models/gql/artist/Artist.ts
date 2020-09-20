import { Field, ObjectType } from 'type-graphql';

@ObjectType()
export class Artist {

  @Field(()=> String)
  public id() {
    return `${ this.name }#${ this.createdAt }`
  }

  @Field()
  public name: string;

  @Field()
  public createdAt: number;
}
