export default interface IContext {
  authorization_token?: string;
  google_authorization_token?: string;
  refresh_token?: string;
  req?: any;
}
