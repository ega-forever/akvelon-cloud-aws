import { Arg, Query, Resolver } from 'type-graphql';
import { Song } from '../../../models/gql/song/Song';
import { Inject } from 'typedi';
import { DI } from '../../../constants/DI';
import * as AWS from 'aws-sdk';
import SongModel from '../../../models/dynamo/song/SongSchema';

@Resolver()
export default class SongResolver {

  @Inject(DI.dynamodb)
  private readonly dynamodb: AWS.DynamoDB;

  @Query(returns => [Song])
  public async songsListByArtist(
    @Arg('artistId', type => String, { nullable: true }) artistId: string,
    @Arg('upperDate', type => Number, { nullable: true }) date: number,
    @Arg('limit', type => Number, { nullable: true, defaultValue: 10 }) limit: number
  ): Promise<Song[]> {

    if (!date) {
      date = Date.now();
    }

    const params = {
      TableName: SongModel.TableName,
      Select: 'ALL_ATTRIBUTES',
      Limit: limit,
      ConsistentRead: false,
      ExpressionAttributeValues: {
        ':artistId': { S: artistId },
        ':releaseDate': { S: date.toString() }
      },
      KeyConditionExpression: 'artistId = :artistId AND releaseDate < :releaseDate',
      IndexName: SongModel.GlobalSecondaryIndexes[0].IndexName,
      ScanIndexForward: false
    };

    const { Items } = await this.dynamodb.query(params).promise();
    const result = [];

    for (const item of Items) {
      result.push({
        name: item.name.S,
        genreType: parseInt(item.genreType.N, 10),
        artistId: item.artistId.S,
        releaseDate: item.releaseDate.S
      })
    }

    return result;
  }

}
