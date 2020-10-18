import { buildSchema } from 'type-graphql';
import { Container } from 'typedi';
import { counterResolvers } from './counter';

export const createSchema = (extra = []) => {
  return buildSchema({
    resolvers: [
      ...extra,
      ...counterResolvers,
    ],
    container: Container
  });
};
