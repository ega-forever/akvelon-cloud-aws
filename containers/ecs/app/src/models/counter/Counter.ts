import { BeforeInsert, BeforeUpdate, Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Field, ObjectType } from 'type-graphql';

@Entity()
@ObjectType()
export class Counter {

  @Field()
  @PrimaryGeneratedColumn()
  public id: number;

  @Field()
  @Column({ default: 0 })
  public count: number;

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
