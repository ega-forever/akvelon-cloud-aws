export default {
  AttributeDefinitions: [
    {
      AttributeName: 'id', // where id is genreType#releaseDate
      AttributeType: 'S'
    },
    {
      AttributeName: 'artistId',
      AttributeType: 'S'
    }
  ],
  KeySchema: [
    {
      AttributeName: 'artistId',
      KeyType: 'HASH'
    },
    {
      AttributeName: 'id',
      KeyType: 'RANGE'
    }
  ],
  ProvisionedThroughput: {
    ReadCapacityUnits: 5,
    WriteCapacityUnits: 5
  },
  TableName: 'Song'
};
