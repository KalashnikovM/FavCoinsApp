import 'package:appwrite/appwrite.dart';
import '../constants.dart';

class ApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(endpoint)
        .setProject(project)
        .setSelfSigned(status: true);

    return client;
  }

  Account get account => Account(_client);

  Databases get database => Databases(_client);

  Realtime get realtime => Realtime(_client);

  Functions get functions => Functions(_client);





}

