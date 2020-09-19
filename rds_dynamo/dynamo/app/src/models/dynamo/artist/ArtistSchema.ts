export default {
  AttributeDefinitions: [
    {
      AttributeName: 'symbol',
      AttributeType: 'S'
    },
    {
      AttributeName: 'createdAt',
      AttributeType: 'S'
    }
  ],
  KeySchema: [
    {
      AttributeName: 'symbol',
      KeyType: 'HASH'
    },
    {
      AttributeName: 'createdAt',
      KeyType: 'RANGE'
    }
  ],
/*  LocalSecondaryIndexes: [
    {
      IndexName: 'index_symbol_createdAt',
      KeySchema: [
        {
          AttributeName: 'symbol',
          KeyType: 'HASH'
        },
        {
          AttributeName: 'createdAt',
          KeyType: 'RANGE'
        }
      ],
      Projection: {
        ProjectionType: 'ALL'
      }
    }
  ],*/
  ProvisionedThroughput: {
    ReadCapacityUnits: 5,
    WriteCapacityUnits: 5
  },
  TableName: 'Artist'
};
