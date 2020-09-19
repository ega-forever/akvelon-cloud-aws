import { buildSchema } from 'type-graphql';
import { Container } from 'typedi';
import { artistResolvers } from './artist';
import { songResolvers } from './song';

export const createSchema = (extra = []) => {
  return buildSchema({
    resolvers: [
      ...extra,
      ...artistResolvers,
      ...songResolvers
    ],
    container: Container
  });
};
