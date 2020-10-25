exports.helloWorld = async (event) => {
  console.log(`function triggered ${Date.now()}`);
  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello world!')
  };
  return response;
};
