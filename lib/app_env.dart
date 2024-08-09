import 'dart:core';


class AppEnv {
  static const String endpoint = String.fromEnvironment('ENDPOINT');
  static const String project = String.fromEnvironment('PROJECT_ID');
  static const String databaseId = String.fromEnvironment('DATABASE_ID');
  static const String top100Collection = String.fromEnvironment('TOP_100_COIN_COLLECTION');
  static const String mainCollection = String.fromEnvironment('MAIN_COIN_COLLECTION');
  static const String coinMapCollection = String.fromEnvironment('COIN_MAP_COLLECTION');
  static const String userCollection = String.fromEnvironment('USER_COLLECTION');
  static const String deleteUserFunctionId = String.fromEnvironment('DELETE_USER_FUNCTION_ID');


}
