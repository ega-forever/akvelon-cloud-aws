export default {
  AttributeDefinitions: [
    {
      AttributeName: 'name',
      AttributeType: 'S'
    },
    {
      AttributeName: 'releaseDate',
      AttributeType: 'S'
    },
    {
      AttributeName: 'artistId',
      AttributeType: 'S'
    }
  ],
  KeySchema: [
    {
      AttributeName: 'name',
      KeyType: 'HASH'
    },
    {
      AttributeName: 'releaseDate',
      KeyType: 'RANGE'
    }
  ],
  GlobalSecondaryIndexes: [
    {
      IndexName: 'index_artistId_releaseDate',
      KeySchema: [
        {
          AttributeName: 'artistId',
          KeyType: 'HASH'
        },
        {
          AttributeName: 'releaseDate',
          KeyType: 'RANGE'
        }
      ],
      Projection: {
        ProjectionType: 'ALL'
      },
      ProvisionedThroughput: {
        ReadCapacityUnits: 5,
        WriteCapacityUnits: 5
      }
    }
  ],
  ProvisionedThroughput: {
    ReadCapacityUnits: 5,
    WriteCapacityUnits: 5
  },
  TableName: 'Song'
};
