FROM node:11.3 AS installer

WORKDIR /usr/src/app
COPY package*.json ./
COPY ./src src
COPY tsconfig.json .
RUN npm install && npm run build

FROM node:11.3-slim

## Clean new directory
WORKDIR /app

## We just need the build and package to execute the command
COPY --from=installer /usr/src/app/build build
RUN cd build && npm install --production

ENTRYPOINT ["node"]
CMD ["build/src/index.js"]
