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
  ProvisionedThroughput: {
    ReadCapacityUnits: 5,
    WriteCapacityUnits: 5
  },
  TableName: 'Artist'
};
