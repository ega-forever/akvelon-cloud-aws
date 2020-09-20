import { Arg, Query, Resolver } from 'type-graphql';
import { Song } from '../../../models/gql/song/Song';
import { Inject } from 'typedi';
import { DI } from '../../../constants/DI';
import * as AWS from 'aws-sdk';
import SongModel from '../../../models/dynamo/song/SongSchema';
import * as bunyan from 'bunyan';

@Resolver()
export default class SongResolver {

  @Inject(DI.dynamodb)
  private readonly dynamodb: AWS.DynamoDB;

  @Inject(DI.logger)
  private readonly logger: bunyan;

  @Query(returns => [Song])
  public async songsListByArtist(
    @Arg('artistId', type => String, { nullable: true }) artistId: string,
    @Arg('lastId', type => String, { nullable: true }) lastId: string,
    @Arg('limit', type => Number, { nullable: true, defaultValue: 10 }) limit: number
  ): Promise<Song[]> {

    const params = {
      TableName: SongModel.TableName,
      Select: 'ALL_ATTRIBUTES',
      Limit: limit,
      ConsistentRead: false,
      ExpressionAttributeValues: {
        ':artistId': { S: artistId }
      },
      KeyConditionExpression: 'artistId = :artistId',
      ScanIndexForward: false,
      ReturnConsumedCapacity: 'TOTAL'
    };

    if (lastId) {
      params.ExpressionAttributeValues[':lastId'] = { S: lastId };
      params.KeyConditionExpression = 'artistId = :artistId AND id < :lastId'
    }

    const { Items, ScannedCount, ConsumedCapacity } = await this.dynamodb.query(params).promise();
    this.logger.info(`consumed ${ ConsumedCapacity.CapacityUnits } units for reading songs list with scanned count ${ ScannedCount }`);
    const result = [];

    for (const item of Items) {
      result.push({
        name: item.name.S,
        genreType: parseInt(item.genreType.N, 10),
        artistId: item.artistId.S,
        releaseDate: item.releaseDate.S,
        id: item.id.S
      })
    }

    return result;
  }

}
