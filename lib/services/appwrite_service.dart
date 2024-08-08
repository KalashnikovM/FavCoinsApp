import 'package:appwrite/appwrite.dart';

import '../app_env.dart';


class ApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(AppEnv.endpoint)
        .setProject(AppEnv.project)
        .setSelfSigned(status: true);

    return client;
  }

  Account get account => Account(_client);

  Databases get database => Databases(_client);

  Realtime get realtime => Realtime(_client);

  Functions get functions => Functions(_client);





}

