import { Arg, Query, Resolver } from 'type-graphql';
import { Artist } from '../../../models/gql/artist/Artist';
import ArtistModel from '../../../models/dynamo/artist/ArtistSchema';
import { Inject } from 'typedi';
import { DI } from '../../../constants/DI';
import * as AWS from 'aws-sdk';

@Resolver()
export default class ArtistResolver {

  @Inject(DI.dynamodb)
  private readonly dynamodb: AWS.DynamoDB;

  @Query(returns => [Artist])
  public async artistList(
    @Arg('symbol', type => String, { nullable: true }) symbol: string,
    @Arg('upperDate', type => Number, { nullable: true }) date: number,
    @Arg('limit', type => Number, { nullable: true, defaultValue: 10 }) limit: number
  ): Promise<Artist[]> {

    if (!date) {
      date = Date.now();
    }

    const params = {
      TableName: ArtistModel.TableName,
      Select: 'ALL_ATTRIBUTES',
      Limit: limit,
      ConsistentRead: false,
      ExpressionAttributeValues: {
        ':symbol': { S: symbol },
        ':date': { S: date.toString() }
      },
      KeyConditionExpression: 'symbol = :symbol AND createdAt < :date',
      ScanIndexForward: false
    };

    const { Items } = await this.dynamodb.query(params).promise();
    const result = [];

    for (const item of Items) {
      result.push({
        name: item.name.S,
        createdAt: item.createdAt.S,
        symbol: item.symbol.S
      })
    }

    return result;
  }

}
