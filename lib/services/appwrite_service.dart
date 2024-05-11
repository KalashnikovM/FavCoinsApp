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

  Storage get storage => Storage(_client);

  Realtime get realtime => Realtime(_client);




}

